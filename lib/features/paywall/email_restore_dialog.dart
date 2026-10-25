/// "Restore with email" (web): the buyer types their checkout email, gets a
/// one-time code by mail and enters it here — no accounts. Shown only when
/// the billing gateway supports [EmailRestore] (the live web gateway).
library;

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../platform/billing/billing.dart';
import '../../theme/hq_theme.dart';

/// The gateway's email restore, or null where it doesn't apply (store and
/// dev builds, and the web demo mode with no payments configured).
EmailRestore? emailRestoreOf(BillingGateway billing) =>
    billing is EmailRestore && billing.backendId != 'demo'
        ? billing as EmailRestore
        : null;

class EmailRestoreDialog extends StatefulWidget {
  const EmailRestoreDialog({super.key, required this.restore});

  final EmailRestore restore;

  /// Resolves true once Premium was restored.
  static Future<bool> show(BuildContext context, EmailRestore restore) async =>
      await showDialog<bool>(
          context: context,
          builder: (_) => EmailRestoreDialog(restore: restore)) ??
      false;

  @override
  State<EmailRestoreDialog> createState() => _EmailRestoreDialogState();
}

class _EmailRestoreDialogState extends State<EmailRestoreDialog> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _email.text.trim();
    if (!email.contains('@') || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await widget.restore.requestRestoreCode(email);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _codeSent = ok;
      if (!ok) _error = context.l.restoreEmailError;
    });
  }

  Future<void> _redeem() async {
    if (_code.text.trim().isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    String? error;
    try {
      final status = await widget.restore
          .redeemRestoreCode(_email.text.trim(), _code.text.trim());
      if (!mounted) return;
      if (status != null && status.isActive) {
        Navigator.of(context).pop(true);
        return;
      }
      error = status == null
          ? context.l.restoreEmailBadCode
          : context.l.commonNoSubscription;
    } catch (_) {
      if (!mounted) return;
      error = context.l.restoreEmailError;
    }
    setState(() {
      _busy = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return AlertDialog(
      title: Text(l.restoreEmailAction),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_codeSent ? l.restoreEmailSent : l.restoreEmailBody),
          const SizedBox(height: 12),
          if (!_codeSent)
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              autofocus: true,
              decoration: InputDecoration(labelText: l.restoreEmailField),
              onSubmitted: (_) => _send(),
            )
          else
            TextField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
              decoration: InputDecoration(labelText: l.restoreEmailCodeField),
              onSubmitted: (_) => _redeem(),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!,
                  style: const TextStyle(color: HqColors.dancheongRed)),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: _busy ? null : (_codeSent ? _redeem : _send),
          child: Text(_codeSent ? l.restoreEmailConfirm : l.restoreEmailSend),
        ),
      ],
    );
  }
}
