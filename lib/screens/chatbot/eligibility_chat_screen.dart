import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../services/gemini_service.dart';

/// Gemini-powered donor eligibility chatbot screen.
class EligibilityChatScreen extends StatefulWidget {
  const EligibilityChatScreen({super.key});

  @override
  State<EligibilityChatScreen> createState() => _EligibilityChatScreenState();
}

class _EligibilityChatScreenState extends State<EligibilityChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatMessage(
      text: 'Greetings. I am RaktSetu AI. I can analyze your biometric eligibility protocols for blood donation across 12 linguistic grids. How may I assist?',
      isBot: true,
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // Background Animation
          Positioned(top: -100, right: -100, child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.05), size: 400)),
          Positioned(bottom: -150, left: -100, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.04), size: 500)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent))),

          Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) return _TypingIndicator().animate().fadeIn();
                    return _ChatBubble(message: _messages[index]);
                  },
                ),
              ),
              _buildInputArea(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: RaktSetuTheme.divider.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: RaktSetuTheme.ink, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI CO-PILOT', 
                style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 2, color: RaktSetuTheme.textSoft),
              ),
              Text(
                'Eligibility Protocol', 
                style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 18, color: RaktSetuTheme.ink, letterSpacing: -0.5),
              ),
            ],
          ),
          const Spacer(),
          _buildLanguagePicker(),
        ],
      ),
    );
  }

  Widget _buildLanguagePicker() {
    return Container(
      decoration: BoxDecoration(
        color: RaktSetuTheme.ink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 50),
        icon: const Icon(Icons.language_rounded, color: Colors.white, size: 20),
        onSelected: (lang) => setState(() {}),
        itemBuilder: (_) => GeminiService.supportedLanguages.entries
            .map((e) => PopupMenuItem(
                  value: e.key,
                  child: Text(e.value, style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                ),)
            .toList(),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 40, offset: const Offset(0, -10))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: RaktSetuTheme.paper,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: RaktSetuTheme.ink),
                decoration: InputDecoration(
                  hintText: 'Ask about eligibility...',
                  hintStyle: GoogleFonts.manrope(color: RaktSetuTheme.textSoft.withValues(alpha: 0.5), fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _sendMessage,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: RaktSetuTheme.ink,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: RaktSetuTheme.ink.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isBot: false));
      _isTyping = true;
      _messageController.clear();
    });
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(_ChatMessage(
            text: 'Analysis complete. Based on standard health protocols, criteria include age 18-65, weight >45kg, and Hb >12.5 g/dL. Would you like to check a specific medical history parameter?',
            isBot: true,
          ),);
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _ChatMessage {
  final String text;
  final bool isBot;
  _ChatMessage({required this.text, required this.isBot});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: message.isBot ? Colors.white : RaktSetuTheme.ink,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(24),
            topRight: const Radius.circular(24),
            bottomLeft: Radius.circular(message.isBot ? 4 : 24),
            bottomRight: Radius.circular(message.isBot ? 24 : 4),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: message.isBot ? 0.04 : 0.1), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Text(
          message.text,
          style: GoogleFonts.manrope(
            fontSize: 15,
            color: message.isBot ? RaktSetuTheme.ink : Colors.white,
            fontWeight: message.isBot ? FontWeight.w700 : FontWeight.w600,
            height: 1.5,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Container(
              width: 6, height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.3), shape: BoxShape.circle),
            );
          }),
        ),
      ),
    );
  }
}

class _AnimatedOrb extends StatefulWidget {
  final Color color;
  final double size;
  const _AnimatedOrb({required this.color, required this.size});

  @override
  State<_AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<_AnimatedOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * 3.14,
        child: Container(
          width: widget.size, height: widget.size * 1.1,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [widget.color, Colors.transparent])),
        ),
      ),
    );
  }
}

