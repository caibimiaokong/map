import 'package:flutter/material.dart';

class NewsButton extends StatelessWidget {
  final String title;

  const NewsButton({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[200]),
          child: Text(
            title,
            style: const TextStyle(color: Colors.black),
          )),
    );
  }
}
