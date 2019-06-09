
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:progress_bar/data/Project.dart';

Future<Uri> CloneProjectLink(Project project)async{
  
  final DynamicLinkParameters params = DynamicLinkParameters(
    link: Uri.parse("https://kashifhussa.in/cloneProject?projectID=" + project.id),
    domain: 'progressbar.page.link',
    socialMetaTagParameters:  SocialMetaTagParameters(
      title: 'Copy of ' + project.name,
      description: 'Click the Link to clone the project!',
    ),
    androidParameters: AndroidParameters(
      packageName: 'com.kashif.progressbar'
    )
  );
  
  final Uri link = await params.buildUrl(); 
  final ShortDynamicLink url = await DynamicLinkParameters.shortenUrl(link, DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable)); 
  return url.shortUrl; 
  
}
Future<Uri> CollabProjectLink(Project project) async {
  final DynamicLinkParameters params = DynamicLinkParameters(
    link: Uri.parse("https://kashifhussa.in/collab?projectID=" + project.id), 
    domain: 'progressbar.page.link',
    socialMetaTagParameters:  SocialMetaTagParameters(
      title: 'Copy of ' + project.name,
      description: 'Click the Link to clone the project!',
    ),
    androidParameters: AndroidParameters(
      packageName: 'com.kashif.progressbar'
    )
  );
  final Uri link = await params.buildUrl(); 
  final ShortDynamicLink url = await DynamicLinkParameters.shortenUrl(link, DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable)); 
  return url.shortUrl; 
}