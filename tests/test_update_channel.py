#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
import json
import pathlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]


class UpdateChannelTests(unittest.TestCase):
    def setUp(self):
        self.root_text = (ROOT / "LOKRO_UPDATE_CHANNEL.json").read_text(encoding="utf-8")
        self.packaged_text = (
            ROOT / "packages/lokro-shell/rootfs/usr/share/lokro/update-channel.json"
        ).read_text(encoding="utf-8")
        self.channel = json.loads(self.root_text)

    def test_packaged_copy_is_exact(self):
        self.assertEqual(self.root_text, self.packaged_text)

    def test_update_source_is_pinned(self):
        self.assertEqual("jamjam1312/LOKROS-Arch-based", self.channel["repository"])
        self.assertEqual("x86_64", self.channel["architecture"])
        self.assertTrue(self.channel["releaseApi"].startswith(
            "https://api.github.com/repos/jamjam1312/LOKROS-Arch-based/releases/tags/v"
        ))

    def test_remote_cannot_enable_unattended_install(self):
        self.assertIs(False, self.channel["automaticPolicy"]["installWithoutLocalConfirmation"])

    def test_timer_policy(self):
        timer = (
            ROOT / "packages/lokro-shell/rootfs/usr/lib/systemd/system/lokro-update.timer"
        ).read_text(encoding="utf-8")
        self.assertIn("OnBootSec=3min", timer)
        self.assertIn("OnUnitActiveSec=5h", timer)
        self.assertIn("Persistent=true", timer)


if __name__ == "__main__":
    unittest.main()
