import 'package:flutter/material.dart';

class Bai2 extends StatelessWidget {
  const Bai2({super.key});

  // Main pink theme color for MoMo
  static const Color momoPink = Color(0xFFA50064);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MoMo Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: momoPink,
        elevation: 0,
        actions: const [
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        children: [
          // Main Menu Grid
          _buildMenuGrid(),

          // Section 1: Sự kiện đang diễn ra
          _buildSectionHeader("Sự kiện đang diễn ra"),
          _buildBanner("assets/image/sukien.png"),

          // Section 2: MoMo đề xuất
          _buildSectionHeader("MoMo đề xuất"),
          _buildPromotionGrid(),

          // Section 3: Another banner (MoMo's recommendation)
          _buildBanner("assets/image/sukien2.png"),

          // Section 4: "Có thể bạn quan tâm" title
          _buildSectionHeader("Có thể bạn quan tâm"),
          const SizedBox(height: 100), // Placeholder for bottom content
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: momoPink,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "MoMo"),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Ưu đãi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Quét mã",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Lịch sử"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Tôi"),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildServiceIcon(Icons.send, "Chuyển tiền", Colors.red),
          _buildServiceIcon(Icons.receipt_long, "Thanh toán\nhóa đơn", Colors.blue),
          _buildServiceIcon(Icons.phone_android, "Nạp tiền điện\nthoại", Colors.teal),
          _buildServiceIcon(Icons.grid_view, "Mua mã thẻ\ndi động", Colors.orange),
          _buildServiceIcon(Icons.pets, "Heo Đất MoMo", Colors.pinkAccent),
          _buildServiceIcon(Icons.directions_walk, "Đi bộ cùng\nMoMo", Colors.green),
          _buildServiceIcon(Icons.water_drop, "Thanh toán\nnước", Colors.lightBlue),
          _buildServiceIcon(Icons.calculate, "Quản lý chi\ntiêu", Colors.indigo),
          _buildServiceIcon(Icons.group, "Quỹ nhóm", Colors.purple),
          _buildServiceIcon(Icons.show_chart, "Chứng Khoán", Colors.blueAccent),
          _buildServiceIcon(Icons.confirmation_number, "Vietlott SMS", Colors.redAccent),
          _buildServiceIcon(Icons.apps, "Xem thêm\ndịch vụ", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPromotionGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildServiceIcon(Icons.monetization_on, "Vay Nhanh", Colors.amber),
          _buildServiceIcon(Icons.movie, "Mua vé xem\nphim", Colors.orange),
          _buildServiceIcon(Icons.savings, "Túi Thần Tài", Colors.deepOrange),
          _buildServiceIcon(Icons.payment, "Ví Trả Sau", Colors.deepPurple),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBanner(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) {
            return Container(
              height: 120,
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
