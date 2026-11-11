import 'package:flutter/material.dart';
import '../../presentation/screens/Loans/application_form/application_status.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String? imagePath;
  final Color backgroundColor;
  final String category;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.imagePath,
    this.backgroundColor = Colors.white,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Top Image
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imagePath!,
                    width: double.infinity,
                    height: constraints.maxWidth > 300 ? 140 : 120,
                    fit: BoxFit.cover,
                  ),
                ),

                // ✅ Text Content
                   Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (subtitle != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        if (description != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            description!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 12),

                        /// ✅ Apply Now - Clickable
                        /*InkWell(
                          onTap: () {
                            if (title.toLowerCase() == "application status") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ApplicationStatusScreen()),
                              );
                            } else {
                              onTap?.call();
                            }
                          },
                          child: Text(
                            title.toLowerCase() == "application status" ? "CLICK HERE" : "APPLY NOW",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        )*/
                      ],
                    ),
                  ),
              ],
            ),
          );
        }
      );
  }
}

/*class ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;

  const ProductCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Top Image
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: constraints.maxWidth > 300 ? 140 : 120,
                  fit: BoxFit.cover,
                ),
              ),

              // ✅ Content Area
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "APPLY NOW",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}*/
