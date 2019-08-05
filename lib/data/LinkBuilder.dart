
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/CRUD.dart';
import 'package:progress_bar/domain/viewmodel.dart';

Future<Uri> CloneProjectLink(Project project)async{
  final DynamicLinkParameters params = DynamicLinkParameters(
    link: Uri.parse("kashifhussa.in/cloneProject?projectID=" + project.id),
    domain: 'https://progressbar.page.link',
    socialMetaTagParameters:  SocialMetaTagParameters(
      title: 'Copy of ' + project.name,
      description: 'Click the Link to clone the project!',
    ),
    
  );
  
  final ShortDynamicLink url = await params.buildShortLink(); 
  return url.shortUrl; 
}

Future<Uri> CollabProjectLink(Project project, List<String> emails, ViewModel model)async {
  List<String> ids = []; 
  //await emails.forEach((email)async => (email.contains('@')) ? ids.add(await FindEmailID(email)):null); 
  for (int i = 0; i < emails.length; i++){
    await ids.add(await FindEmailID(emails[i]));
  }
  project.users = []; 
  for (int i =0 ;i < ids.length; i++){
    if (!project.users.contains(ids[i])){
      project.users.add(ids[i]); 
    }
  }
  model.onUpdateProjectSettings(project); 
  final DynamicLinkParameters params = DynamicLinkParameters(
    link: Uri.parse("https://kashifhussa.in/collab?projectID=" + project.id), 
    domain: 'progressbar.page.link',
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