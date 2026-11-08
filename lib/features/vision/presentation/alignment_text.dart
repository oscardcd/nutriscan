import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';
import '../domain/pose_alignment.dart';

/// Texto e icono del hint. `null` = todavía no hay pose evaluada.
(String, IconData) alignmentReadout(Translations t, AlignmentHint? hint) =>
    switch (hint) {
      null => (t.capture.alignmentSearching, Icons.person_search_outlined),
      AlignmentHint.ok => (t.capture.alignmentOk, Icons.verified_outlined),
      AlignmentHint.incompleteBody => (
        t.capture.alignmentIncomplete,
        Icons.accessibility_new,
      ),
      AlignmentHint.tooFar => (t.capture.alignmentTooFar, Icons.zoom_in),
      AlignmentHint.tooClose => (t.capture.alignmentTooClose, Icons.zoom_out),
      AlignmentHint.notCentered => (
        t.capture.alignmentNotCentered,
        Icons.filter_center_focus,
      ),
      AlignmentHint.tilted => (t.capture.alignmentTilted, Icons.straighten),
      AlignmentHint.notFrontal => (
        t.capture.alignmentNotFrontal,
        Icons.screen_rotation_outlined,
      ),
      AlignmentHint.armsCoveringTorso => (
        t.capture.alignmentArms,
        Icons.accessibility,
      ),
    };
