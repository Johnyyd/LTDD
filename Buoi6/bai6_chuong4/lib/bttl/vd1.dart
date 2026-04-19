import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class Bai1 extends StatefulWidget {
  const Bai1({super.key});

  @override
  State<Bai1> createState() => _MediaPickerHomeState();
}

class _MediaPickerHomeState extends State<Bai1> {
  File? _mediaFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isDenied) {
      await permission.request();
    }
  }

  Future<void> _pickMedia(ImageSource source, bool isVideo) async {
    setState(() => _isLoading = true);
    try {
      // Request permissions based on type
      if (source == ImageSource.gallery) {
        if (Platform.isAndroid) {
          await _requestPermission(
            isVideo ? Permission.videos : Permission.photos,
          );
        } else {
          await _requestPermission(Permission.photos);
        }
      } else {
        await _requestPermission(Permission.camera);
        if (isVideo) await _requestPermission(Permission.microphone);
      }

      final XFile? pickedFile = isVideo
          ? await _picker.pickVideo(source: source)
          : await _picker.pickImage(
              source: source,
              imageQuality: 100,
              maxWidth: 1920,
              maxHeight: 1080,
            );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        await _handleSelectedFile(file, isVideo || file.path.endsWith('.mp4'));
      }
    } catch (e) {
      _showSnackBar('Error picking media: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSelectedFile(File file, bool isVideo) async {
    _videoController?.dispose();
    _videoController = null;

    if (isVideo) {
      _videoController = VideoPlayerController.file(file);
      try {
        await _videoController!.initialize();
        _videoController!.setLooping(true);
        _videoController!.play();
      } catch (e) {
        _showSnackBar('Error initializing video: $e');
      }
    }

    setState(() {
      _mediaFile = file;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Media Picker App'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.05),
              colorScheme.secondary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPreviewSection(colorScheme),
              const SizedBox(height: 32),
              Text(
                'Actions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              _buildActionGrid(colorScheme),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection(ColorScheme colorScheme) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_mediaFile == null && !_isLoading)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 80,
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No media selected',
                  style: TextStyle(
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          if (_isLoading)
            const CircularProgressIndicator()
          else if (_mediaFile != null)
            _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : Image.file(
                    _mediaFile!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          if (_videoController != null && _videoController!.value.isInitialized)
            Positioned(
              bottom: 12,
              right: 12,
              child: FloatingActionButton.small(
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  });
                },
                backgroundColor: Colors.black45,
                child: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(ColorScheme colorScheme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildActionCard(
          icon: Icons.photo_library,
          label: 'Gallery Photo',
          color: colorScheme.primary,
          onTap: () => _pickMedia(ImageSource.gallery, false),
        ),
        _buildActionCard(
          icon: Icons.camera_alt,
          label: 'Camera Photo',
          color: colorScheme.secondary,
          onTap: () => _pickMedia(ImageSource.camera, false),
        ),
        _buildActionCard(
          icon: Icons.video_library,
          label: 'Gallery Video',
          color: Colors.orange,
          onTap: () => _pickMedia(ImageSource.gallery, true),
        ),
        _buildActionCard(
          icon: Icons.videocam,
          label: 'Camera Video',
          color: Colors.redAccent,
          onTap: () => _pickMedia(ImageSource.camera, true),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
