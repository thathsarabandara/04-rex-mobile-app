import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello Thathsara! I am REX, your smart assistant. How can I help you today?',
      'isUser': false,
      'time': '12:00 PM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isUser': true,
        'time': 'Just now',
      });
      final userText = _messageController.text;
      _messageController.clear();

      // Simple mock responses
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          String response = 'I\'ve received that instruction. Processing...';
          if (userText.toLowerCase().contains('battery')) {
            response = 'The current battery level of REX-47 is 82%. It is discharging normally.';
          } else if (userText.toLowerCase().contains('patrol')) {
            response = 'Initiating patrol sequence. I will notify you if any anomalies are detected.';
          } else if (userText.toLowerCase().contains('status')) {
            response = 'All systems are functional. Compute temperature is stable at 37°C. Network signal is strong.';
          }
          _messages.add({
            'text': response,
            'isUser': false,
            'time': 'Just now',
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 350,
            child: CustomPaint(painter: HeaderWavePainter(isDark: isDark)),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AI Assistant',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.volume_up_rounded, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: isLight 
                              ? Colors.black.withValues(alpha: 0.05) 
                              : Colors.black.withValues(alpha: 0.3), 
                          blurRadius: 24, 
                          offset: const Offset(0, -8),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      child: Column(
                        children: [
                          // Messages List
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                              reverse: false,
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final message = _messages[index];
                                final isUser = message['isUser'] as bool;
                                return SlideFade(
                                  animation: _animController,
                                  delay: 0.1,
                                  child: Align(
                                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                      decoration: BoxDecoration(
                                        color: isUser 
                                            ? primary 
                                            : theme.cardColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
                                          bottomLeft: Radius.circular(isUser ? 20 : 4),
                                          bottomRight: Radius.circular(isUser ? 4 : 20),
                                        ),
                                        border: isUser 
                                            ? null 
                                            : Border.all(color: theme.dividerColor),
                                        boxShadow: isUser 
                                            ? [BoxShadow(color: primary.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] 
                                            : [],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message['text'] as String,
                                            style: TextStyle(
                                              color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
                                              fontSize: 14,
                                              height: 1.4,
                                              fontWeight: isUser ? FontWeight.w600 : FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              message['time'] as String,
                                              style: TextStyle(
                                                color: isUser ? Colors.white70 : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Quick actions list
                          Container(
                            height: 44,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              children: [
                                _buildQuickChip('Check Battery Status', Icons.battery_std_rounded),
                                _buildQuickChip('Initiate Patrol', Icons.explore_rounded),
                                _buildQuickChip('Check System Temperature', Icons.thermostat_rounded),
                                _buildQuickChip('Go Home', Icons.home_rounded),
                              ],
                            ),
                          ),

                          // Message Input Bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(color: theme.dividerColor),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 12),
                                        IconButton(
                                          icon: Icon(Icons.mic_none_rounded, color: primary),
                                          onPressed: () {},
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _messageController,
                                            decoration: const InputDecoration(
                                              hintText: 'Ask REX something...',
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                            ),
                                            onSubmitted: (_) => _sendMessage(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                BouncingCard(
                                  onTap: _sendMessage,
                                  child: CircleAvatar(
                                    radius: 26,
                                    backgroundColor: primary,
                                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String text, IconData icon) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return BouncingCard(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: primary),
            const SizedBox(width: 8),
            Text(
              text, 
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold, 
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
