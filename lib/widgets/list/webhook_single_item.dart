import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'dart:async';

class SingleWebhook extends StatefulWidget {
  final Map<String, dynamic>? webhook;
  final Function(Map<String, dynamic>) onPlayPressed;
  final Function(int) onDeletePressed;

  const SingleWebhook({
    Key? key,
    required this.webhook,
    required this.onPlayPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  _SingleWebhookState createState() => _SingleWebhookState();
}

class _SingleWebhookState extends State<SingleWebhook> {
  bool isLoading = false;
  bool isSuccess = false;
  bool isFailure = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GlassmorphicContainer(
        border: 2,
        width: double.infinity,
        height: 100,
        borderRadius: 8,
        blur: 20,
        alignment: Alignment.center,
        linearGradient: isSuccess
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.greenAccent.withOpacity(0.2),
                  Colors.lightGreenAccent.withOpacity(0.1),
                ],
                stops: const [0.1, 1],
              )
            : isFailure
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.redAccent.withOpacity(0.5),
                      Colors.red.withOpacity(0.4),
                    ],
                    stops: const [0.1, 1],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purpleAccent.withOpacity(0.2),
                      Colors.deepPurpleAccent.withOpacity(0.1),
                    ],
                    stops: const [0.1, 1],
                  ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.withOpacity(0.5),
            Colors.grey.withOpacity(0.2),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
            child: Text(
              widget.webhook?['name'] as String? ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              widget.webhook?['url'] as String? ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              isLoading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      onPressed: () async {
                        if (widget.webhook != null) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await widget.onPlayPressed(widget.webhook!);
                            setState(() {
                              isLoading = false;
                              isSuccess = true;
                              isFailure = false;
                            });
                            Timer(const Duration(seconds: 3), () {
                              setState(() {
                                isSuccess = false;
                              });
                            });
                          } catch (e) {
                            print('Error: $e');
                            setState(() {
                              isLoading = false;
                              isSuccess = false;
                              isFailure = true;
                            });
                            Timer(const Duration(seconds: 3), () {
                              setState(() {
                                isFailure = false;
                              });
                            });
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.play_circle_fill_sharp,
                        color: Colors.green,
                      ),
                    ),
              IconButton(
                onPressed: () {
                  widget.onDeletePressed(widget.webhook?['id'] as int? ?? 0);
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
