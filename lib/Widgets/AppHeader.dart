import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class tittle extends StatelessWidget {
  const tittle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 27, left: 20, right: 20),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            color: Colors.black,
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SvgPicture.asset(
                    'lib/assets/logopendarungan.svg',
                    width: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Text(
                    'Desa Pendarungan',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
