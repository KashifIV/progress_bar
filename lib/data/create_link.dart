
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/CRUD.dart';
import 'package:progress_bar/data/Project.dart';

Future<Uri> CloneProjectLink(Project project)async{
  
  final DynamicLinkParameters params = DynamicLinkParameters(
    link: Uri.parse("https://kashifhussa.in/cloneProject?projectID=" + project.id),
    uriPrefix: 'https://progressbar.page.link',
    dynamicLinkParametersOptions: DynamicLinkParametersOptions(
      shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
    ),
    socialMetaTagParameters:  SocialMetaTagParameters(
      title: 'Copy of ' + project.name,
      description: 'Click the Link to clone the project!',
    ),
    androidParameters: AndroidParameters(
      packageName: 'com.kashif.progressbar'
    ), 
    iosParameters: IosParameters(
      bundleId: 'com.kashif.progressbar', 
      minimumVersion: '1.0.1',
    )
  );
  print('building link');
  final Uri link = await params.buildUrl(); 
  final ShortDynamicLink url = await DynamicLinkParameters.shortenUrl(link, DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable)); 
  return url.shortUrl; 
  
}
Future<Uri> CollabProjectLink(Account account,Project project, List<String> authenticatedUsers) async {
  await createAuthenticationDoc(account, project, authenticatedUsers); 
  final DynamicLinkParameters params = DynamicLinkParameters(
    link: Uri.parse("https://kashifhussa.in/collab?projectID=" + project.id), 
    uriPrefix: 'progressbar.page.link',
    socialMetaTagParameters:  SocialMetaTagParameters(
      title: 'Copy of ' + project.name,
      description: 'Click the Link to Join the Project!',
    ),
    androidParameters: AndroidParameters(
      packageName: 'com.kashif.progressbar'
    )
  );
  final Uri link = await params.buildUrl(); 
  final ShortDynamicLink url = await DynamicLinkParameters.shortenUrl(link, DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable)); 
  return url.shortUrl; 
}