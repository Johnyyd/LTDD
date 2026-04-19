import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class Bai3 extends StatelessWidget {
  const Bai3({super.key});

  final Color momoPink = const Color(0xFFD82D8B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Main App",
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
          Text("Welcome to the main App!"),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactsReaderApp(),
                ),
              );
            },
            child: Text("Go to SMS Reader App"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SmsReaderApp()),
              );
            },
            child: Text("Go to Contact Reader App"),
          ),
        ],
      ),
    );
  }
}

class ContactsReaderApp extends StatelessWidget {
  const ContactsReaderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts Reader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ContactsReaderHome(),
    );
  }
}

class ContactsReaderHome extends StatefulWidget {
  const ContactsReaderHome({super.key});
  @override
  State<ContactsReaderHome> createState() => _ContactsReaderHomeState();
}

class _ContactsReaderHomeState extends State<ContactsReaderHome> {
  List<Contact> _contacts = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    // Yêu cầu quyền truy cập danh bạ
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
    ].request();
    if (statuses[Permission.contacts]!.isGranted) {
      _loadContacts();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng cấp quyền để đọc danh bạ!')),
      );
    }
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });
    // Lấy danh bạ

    List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Reader')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(child: Text('Không có danh bạ nào.'))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(
                    contact.phones.isNotEmpty
                        ? contact.phones.first.number
                        : 'Không có số',
                  ),
                );
              },
            ),
    );
  }
}

class SmsReaderApp extends StatelessWidget {
  const SmsReaderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Reader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SmsReaderHome(),
    );
  }
}

class SmsReaderHome extends StatefulWidget {
  const SmsReaderHome({super.key});
  @override
  State<SmsReaderHome> createState() => _SmsReaderHomeState();
}

class _SmsReaderHomeState extends State<SmsReaderHome> {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> _messages = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    // Yêu cầu quyền SMS
    Map<Permission, PermissionStatus> statuses = await [
      Permission.sms,
      Permission.phone,
    ].request();
    if (statuses[Permission.sms]!.isGranted) {
      _loadMessages();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng cấp quyền để đọc tin nhắn SMS!'),
        ),
      );
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });
    // Lấy tin nhắn từ hộp thư đến
    List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY,
        SmsColumn.DATE,
        SmsColumn.TYPE,
      ],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );

    setState(() {
      _messages = messages;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS Reader')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _messages.isEmpty
          ? const Center(child: Text('Không có tin nhắn nào.'))
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                SmsMessage message = _messages[index];
                return ListTile(
                  title: Text(message.body ?? 'Không có nội dung'),
                  subtitle: Text('Từ: ${message.address ?? 'Không rõ'}'),
                );
              },
            ),
    );
  }
}
