import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardCount extends StatefulWidget {
  const CardCount(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.count});

  final IconData icon;
  final String title;
  final String subtitle;
  final String count;

  @override
  State<CardCount> createState() => _CardCountState();
}

class _CardCountState extends State<CardCount> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 25) / 2,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Icon(
                    widget.icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.robotoCondensed(
                            height: 1,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.robotoCondensed(
                            height: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '15',
                      style: TextStyle(
                        height: 1,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
