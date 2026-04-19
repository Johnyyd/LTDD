import 'package:flutter/material.dart';

class Bai3 extends StatelessWidget {
  const Bai3({super.key});

  final Color momoPink = const Color(0xFFD82D8B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Quà của Vinh (7)",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFEBEE),
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black87),
        actions: const [
          Icon(Icons.qr_code_scanner, color: Colors.black87),
          SizedBox(width: 8),
          Icon(Icons.cancel_outlined, color: Colors.black87),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip(Icons.filter_list, "", true),
                _buildFilterChip(
                  null,
                  "Sắp xếp",
                  false,
                  trailingIcon: Icons.arrow_drop_down,
                ),
                _buildFilterChip(
                  null,
                  "Dịch vụ",
                  false,
                  trailingIcon: Icons.keyboard_arrow_down,
                ),
                _buildFilterChip(null, "Gần tôi", false),
                _buildFilterChip(null, "Yêu thích", false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Summary Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    "Đang có",
                    "1.955 Xu",
                    Icons.monetization_on,
                    Colors.amber,
                    Colors.amber[50]!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    "Bỏ túi ngay",
                    "4 thẻ quà",
                    Icons.card_giftcard,
                    Colors.white,
                    const Color(0xFF3F51B5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Voucher List
          _buildVoucherCard(
            "CGV",
            "Đồng giá 79K khi mua vé CGV 2D trên M...",
            "HSD: 24/03/2025",
            Icons.movie,
            Colors.red,
            "Dùng ngay",
          ),
          _buildVoucherCard(
            "Giảm 100K",
            "Cho đơn từ 0đ - Mua Sim chính chủ",
            "HSD: 28/02/2025",
            Icons.sim_card,
            Colors.purple,
            "Dùng ngay",
            isNew: true,
          ),
          _buildVoucherCard(
            "Tặng 100k",
            "Khi mở thẻ VIB Online Plus 2in1 (*)",
            "HSD: 31/03/2025",
            Icons.credit_card,
            Colors.blue,
            "Dùng ngay",
          ),
          _buildVoucherCard(
            "Hoàn 15K",
            "Cho hóa đơn từ 3.000.000đ - Bảo hiểm",
            "Hết hạn sau 5 ngày",
            Icons.umbrella,
            Colors.lightBlue,
            "Dùng ngay",
          ),
          _buildVoucherCard(
            "Giảm 10K",
            "Cho đơn từ 100K - Phí không dừng",
            "HSD: 15/04/2025",
            Icons.directions_car,
            Colors.orange,
            "Thu thập",
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    IconData? icon,
    String label,
    bool isSelected, {
    IconData? trailingIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 16, color: Colors.black87),
          if (icon != null && label.isNotEmpty) const SizedBox(width: 4),
          if (label.isNotEmpty)
            Text(label, style: const TextStyle(fontSize: 13)),
          if (trailingIcon != null)
            Icon(trailingIcon, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: bgColor == Colors.white
            ? Border.all(color: Colors.amber[200]!)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: bgColor == Colors.white
                      ? Colors.black54
                      : Colors.white70,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: bgColor == Colors.white
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(
    String title,
    String desc,
    String hsd,
    IconData icon,
    Color color,
    String btnText, {
    bool isNew = false,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (isNew) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.favorite, color: Colors.pink, size: 14),
                    ],
                  ],
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  hsd,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    btnText,
                    style: TextStyle(
                      color: momoPink,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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
}
