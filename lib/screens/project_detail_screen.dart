// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    // image_src can be a path such as /static/..., relative to the backend.
    final imageUrl = Uri.parse(context.read<ApiClient>().baseUrl)
        .resolve(project.imageSrc)
        .toString();

    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.projectImageUrl.isNotEmpty) ...[
              Image.network(
                imageUrl,
                // Falls back to <img> on web, where static files lack CORS.
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Image could not be loaded.'),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Year: ${project.year}'),
            Text('Tech Stack: ${project.techStack}'),
            if (project.projectUrl.isNotEmpty)
              SelectableText('Project URL: ${project.projectUrl}'),
            if (project.repoUrl.isNotEmpty)
              SelectableText('Repository: ${project.repoUrl}'),
            const SizedBox(height: 16),
            Text(project.description),
          ],
        ),
      ),
    );
  }
}
