import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/plant_model.dart';
import '../../services/file_upload.dart';
import '../../viewmodels/authe_viewmodel.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/single_product_viewmodel.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleProductViewModel>(create: (_) => SingleProductViewModel(), child: EditProductBody());
  }
}

class EditProductBody extends StatefulWidget {
  const EditProductBody({Key? key}) : super(key: key);

  @override
  State<EditProductBody> createState() => _EditProductBodyState();
}

class _EditProductBodyState extends State<EditProductBody> {
  TextEditingController _plantNameController = TextEditingController();
  TextEditingController _plantTemperatureController = TextEditingController();
  TextEditingController _plantDescriptionController = TextEditingController();
  String productCategory = "";

  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late SingleProductViewModel _singleProductViewModel;
  String? productId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      _singleProductViewModel = Provider.of<SingleProductViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        productId = args;
      });
      print(args);
      getData(args);
    });
    super.initState();
  }
  File? pickedImage;
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
          child: Container(
            color: Colors.blue,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void editProduct() async {
    if (pickedImage == null) {
      return;
    }
    _ui.loadState(true);
    Reference storageRef = FirebaseStorage.instance.ref();
    String dt = DateTime.now().millisecondsSinceEpoch.toString();
    var photo = await storageRef.child("plants").child("$dt.jpg").putFile(File(pickedImage!.path));
    var url = await photo.ref.getDownloadURL();
    try{
      final PlantModel data= PlantModel(
        imagePath: photo.ref.fullPath,
        imageUrl: url,
        categoryId: selectedCategory,
        plantDescription: _plantDescriptionController.text,
        plantName: _plantNameController.text,
        temperatura: num.parse(_plantTemperatureController.text.toString()),
        userId: _authViewModel.loggedInUser!.userId,
      );
      await _authViewModel.editMyProduct(data, productId!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
      Navigator.of(context).pop();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
    }
    _ui.loadState(false);
  }

  getData(String args) async {
    _ui.loadState(true);
    try {
      await _categoryViewModel.getCategories();

      await _singleProductViewModel.getProducts(args);
      PlantModel? plant = _singleProductViewModel.plant;

      if (plant != null) {
        _plantNameController.text = plant.plantName ?? "";
        _plantTemperatureController.text = plant.temperatura==null ? "" : plant.temperatura.toString();
        _plantDescriptionController.text = plant.plantDescription ?? "";
        setState(() {
          selectedCategory = plant.categoryId;
          imageUrl = plant.imageUrl;
          imagePath = plant.imagePath;
        });
      }
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }

  String? selectedCategory;

  // image uploader
  String? imageUrl;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected = await _picker.pickImage(source: source, imageQuality: 100);
    if (selected != null) {
      setState(() {
        imageUrl = null;
        imagePath = null;
      });

      _ui.loadState(true);
      try {
        ImagePath? image = await FileUpload().uploadImage(selectedPath: selected.path);
        if (image != null) {
          setState(() {
            imageUrl = image.imageUrl;
            imagePath = image.imagePath;
          });
        }
      } catch (e) {
        print(e);
      }

      _ui.loadState(false);
    }
  }
  // void deleteImage() async {
  //   _ui.loadState(true);
  //   try {
  //     await FileUpload().deleteImage(deletePath: imagePath.toString()).then((value) {
  //       setState(() {
  //         imagePath = null;
  //         imageUrl = null;
  //       });
  //     });
  //   } catch (e) {}
  //
  //   _ui.loadState(false);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleProductViewModel>(
      builder: (context, singleProductVM, child) {
        if(_singleProductViewModel.plant== null)
          return Text("Error");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black54,
            title: Text("Edit a plant"),
          ),
          body: Consumer<CategoryViewModel>(builder: (context, categoryVM, child) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _plantNameController,
                        // validator: ValidateProduct.username,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          border: InputBorder.none,
                          label: Text("Plant Name"),
                          hintText: 'Enter plant name',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _plantTemperatureController,
                        // validator: ValidateProduct.username,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          border: InputBorder.none,
                          label: Text("Plant temperature"),
                          hintText: 'Enter plant tempreature',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _plantDescriptionController,
                        // validator: ValidateProduct.username,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          border: InputBorder.none,
                          label: Text("Plant Description"),
                          hintText: 'Enter Plant description',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Category",
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                        ),
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: categoryVM.categories.map((pt) {
                          return DropdownMenuItem(
                            value: pt.id.toString(),
                            child: Text(
                              pt.categoryName.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            selectedCategory = newVal.toString();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.6), width: 2),
                              ),
                              child: ClipRect(
                                child: pickedImage != null
                                    ? Image.file(
                                  pickedImage!,
                                  width: 500,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                                    : Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/-Insert_image_here-.svg/320px--Insert_image_here-.svg.png?20220802103107',
                                  // width: 500,
                                  // height: 800,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                            onPressed: imagePickerOption,
                            icon: const Icon(Icons.add_a_photo_sharp),
                            label: const Text('Image here')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.blue))),
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                            ),
                            onPressed: () {
                              editProduct();
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.orange))),
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }
    );
  }
}
