import 'package:flutter/material.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/utils/clipboard_utils.dart';
import 'package:wedding/utils/color_utils.dart';

Widget accountWidget(AccountRaw raw, double? horizontalPadding) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20.0),
    child: Column(
      children: [_AccountWidget(raw: raw), itemsGap],
    ),
  );
}

class _AccountWidget extends StatefulWidget {
  final AccountRaw raw;

  const _AccountWidget({
    required this.raw,
  });

  @override
  State<_AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<_AccountWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _controller.value = 1.0; // 초기 상태는 펼쳐진 상태
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.raw.bgColor?.toColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Center(
            child: InkWell(
              onTap: _toggleExpand,
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      widget.raw.title,
                      style: titleStyle2,
                      textAlign: TextAlign.center,
                    ),
                    Positioned(
                      right: 0,
                      child: AnimatedRotation(
                        turns: isExpanded ? 0 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizeTransition(
            axisAlignment: 0.0,
            sizeFactor: _controller,
            child: Column(
              children: [
                const SizedBox(height: 24),
                ...widget.raw.account.map((item) => Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,  // 복사 버튼 수직 가운데 정렬
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: bodyStyle2.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.accountNumber,
                                  style: bodyStyle2,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: copyButtonWidget(context, item.accountNumber),
                          ),
                        ],
                      ),
                    ),
                    if (widget.raw.account.last != item) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: CustomPaint(
                          size: const Size(double.infinity, 1),
                          painter: DottedLinePainter(),
                        ),
                      )
                    ],
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget copyButtonWidget(BuildContext context, String accountNumber) {
  return Material(
    color: Colors.white,
    child: InkWell(
      onTap: () {
        ClipboardUtils.copy(context, text: accountNumber, snackBarMessage: '계좌번호가 복사되었습니다.');
      },
      borderRadius: BorderRadius.circular(8),
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.content_copy,
              size: 14,
              color: Colors.black,
            ),
            SizedBox(width: 4),
            Text(
              '복사하기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    const double dashWidth = 2;
    const double dashSpace = 2;
    double startX = 0;
    final double endX = size.width;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}