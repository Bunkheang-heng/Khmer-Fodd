import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/recipe.dart';

class RecipeInstructions extends StatelessWidget {
  final Recipe recipe;

  const RecipeInstructions({super.key, required this.recipe});

  String? _getYoutubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.host == 'youtu.be') {
      return uri.pathSegments.first;
    } else if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'];
    }
    return null;
  }

  Widget _buildVideoPlayer(String videoUrl) {
    final videoId = _getYoutubeVideoId(videoUrl);
    if (videoId == null) return Container();

    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    );

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
      ),
      builder: (context, player) {
        return Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: player,
          ),
        );
      },
    );
  }

  Widget _buildInstructionItem(int index, String instruction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {}, // Add interaction feedback
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade600,
                        Colors.green.shade400,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    instruction,
                    style: TextStyle(
                      fontFamily: 'Koulen',
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.green.shade900,
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

  @override
  Widget build(BuildContext context) {
    final headerDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green.shade700, Colors.green.shade500],
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.green.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: headerDecoration,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'វិធីធ្វើ:',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Chenla',
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (recipe.videoUrl != null && recipe.videoUrl!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildVideoPlayer(recipe.videoUrl!),
              ],
              const SizedBox(height: 16),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recipe.instructions.length,
                itemBuilder: (context, index) {
                  return _buildInstructionItem(
                    index,
                    recipe.instructions[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
