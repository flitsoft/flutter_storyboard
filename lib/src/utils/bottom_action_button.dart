import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BottomActionButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? color;
  final VoidCallback? onPressed;
  final double width;
  final double? padding;
  final Widget Function()? builder;

  const BottomActionButton({
    Key? key,
    this.text = "",
    this.backgroundColor,
    this.onPressed,
    this.width: 250.0,
    this.color: Colors.white,
    this.builder,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      padding: EdgeInsets.symmetric(
        horizontal: padding ?? MediaQuery.of(context).size.width * .025,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ButtonTheme(
                minWidth: width,
                child: ElevatedButton(
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: builder == null
                          ? AutoSizeText(
                              text,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: color,
                                fontSize: 20.0,
                              ),
                            )
                          : builder!(),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(backgroundColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                    elevation: MaterialStateProperty.all(5.0),
                  ),
                  onPressed: onPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
