#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
import importlib.machinery
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True


ROOT = Path(__file__).resolve().parent.parent
SCRIPT = ROOT / "packages/lokro-shell/rootfs/usr/bin/lokro-services-merge"
WORK = ROOT / "work"


def load_merger():
    loader = importlib.machinery.SourceFileLoader("lokro_services_merge", str(SCRIPT))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


class ServiceMergeTests(unittest.TestCase):
    def setUp(self):
        WORK.mkdir(exist_ok=True)
        self.temp = tempfile.TemporaryDirectory(dir=WORK)
        self.root = Path(self.temp.name)
        self.fragments = self.root / "fragments"
        self.fragments.mkdir()
        self.base = self.root / "base.json"
        self.output = self.root / "state/services.json"
        self.module = load_merger()
        self.module.BASE = self.base
        self.module.FRAGMENTS = self.fragments
        self.module.OUTPUT = self.output

    def tearDown(self):
        self.temp.cleanup()

    @staticmethod
    def service(identifier, name):
        return {
            "id": identifier,
            "name": name,
            "url": f"https://example.test/{identifier}",
            "icon": "network-server",
        }

    def write(self, path, document):
        path.write_text(json.dumps(document), encoding="utf-8")

    def test_sorted_fragments_override_base_by_id(self):
        self.write(self.base, {"services": [self.service("status", "Base"), self.service("chat", "Chat")]})
        self.write(self.fragments / "10-status.json", [self.service("status", "First override")])
        self.write(self.fragments / "20-status.json", {"services": [self.service("status", "Final override")]})

        self.module.main()

        result = json.loads(self.output.read_text(encoding="utf-8"))
        self.assertEqual([entry["id"] for entry in result["services"]], ["status", "chat"])
        self.assertEqual(result["services"][0]["name"], "Final override")

    def test_invalid_fragment_does_not_replace_existing_output(self):
        self.write(self.base, {"services": [self.service("status", "Base")]})
        self.output.parent.mkdir(parents=True)
        self.write(self.output, {"services": [self.service("old", "Existing")]})
        self.write(self.fragments / "bad.json", {"services": [{"id": "missing-fields"}]})

        with self.assertRaises(ValueError):
            self.module.main()

        result = json.loads(self.output.read_text(encoding="utf-8"))
        self.assertEqual(result["services"][0]["id"], "old")


if __name__ == "__main__":
    unittest.main()
