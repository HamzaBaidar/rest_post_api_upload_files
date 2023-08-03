import "dart:io";
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
class PostApi extends StatefulWidget {
  const PostApi({Key? key}) : super(key: key);

  @override
  State<PostApi> createState() => _PostApiState();
}
class _PostApiState extends State<PostApi> {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(
          color: Colors.green,
          fontSize: 20
        ),),
        duration: Duration(seconds: 15),
      ),
    );
  }
 File? image;
 final _picker=ImagePicker();
 bool showSpinner=false;
 Future getimage() async{
   final pickedfile= await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80 );
   if(pickedfile!=null){
     image= File(pickedfile.path);
     setState(() {
     });
   }
   else{
     print("No image Selected");
   }

}
Future<void> UploadImage() async{
   setState(() {
     showSpinner=true;
   });
   var stream = new http.ByteStream(image!.openRead());
   stream.cast();
   var length= await image!.length();
   var uri=Uri.parse("https://fakestoreapi.com/products");
   var request= new http.MultipartRequest('Post', uri);
   request.fields['title']= 'Static title';
   var multiport= new http.MultipartFile(
       'image',
       stream,
       length);
   request.files.add(multiport);
   var response= await request.send();
   print(response.stream.toString());
   if(response.statusCode==200){
     setState(() {
       showSpinner=false;
     });
     print("Image Uploaded");
     showSnackBar("Image has been uploaded");
   }
   else{
     setState(() {
       showSpinner=false;
     });
     print('Failed');
   }
}

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
              "PostApiUploadFile"
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                getimage();
              },
              child: Container(
                child:  image==null? const Center(child: Text("Pick Image"))
              :
                    Container(
                      height: 200,
                      width: 300,
                      child: Center(
                        child: Image.file(
                          // we should import dart:io not dart:html
                          File(image!.path).absolute,
                          fit: BoxFit.cover,

                        )
                      ),
                    )
              ),
            ),
            SizedBox(height: 150,),
            GestureDetector(
              onTap: (){
                UploadImage();
              },
              child: Center(
                child: Container(
                  height: 50,
                 width: 200,
                 color: Colors.green,
                  child: const Center(child: Text("Upload",style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),)),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
