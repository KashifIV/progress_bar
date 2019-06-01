
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:progress_bar/data/Project.dart';

Future<Uri> CloneProjectLink(Project project)async{
  final DynamicLinkParameters params = DynamicLinkParameters(
    link: Uri.parse("kashifhussa.in/cloneProject?projectID=" + project.id),
    uriPrefix: 'https://progressbar.page.link',
    socialMetaTagParameters:  SocialMetaTagParameters(
      title: 'Copy of ' + project.name,
      description: 'Click the Link to clone the project!',
    ),
    
  );
  
  final ShortDynamicLink url = await params.buildShortLink(); 
  return url.shortUrl; 
}