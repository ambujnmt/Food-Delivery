import 'package:flutter/material.dart';
import 'package:food_delivery/api_services/api_service.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  dynamic size;
  final customText = CustomText();
  bool isApiCalling = false;
  final api = API();
  List<dynamic> imagesList = [];

  galleryImagesData() async {
    setState(() {
      isApiCalling = true;
    });
    final response = await api.galleryImages();
    setState(() {
      imagesList = response['data'];
    });
    setState(() {
      isApiCalling = false;
    });

    if (response["status"] == true) {
      print('about us success message: ${response["message"]}');
    } else {
      print('about us error message: ${response["message"]}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    galleryImagesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: isApiCalling
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.kPrimary,
                ),
              )
            : imagesList.isEmpty
                ? Center(
                    child: Container(
                      height: size.height * 0.25,
                      width: size.width,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8)),
                          height: 50,
                          width: size.width * .400,
                          child: Center(
                            child: customText.kText(
                                "No data found",
                                15,
                                FontWeight.w700,
                                Colors.black,
                                TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: size.height,
                    width: size.width,
                    padding: EdgeInsets.only(bottom: size.height * 0.02),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(bottom: size.height * 0.01),
                            child: Column(
                              children: [
                                Container(
                                  height: size.height * 0.06,
                                  width: size.width,
                                  color: Colors.grey.shade300,
                                ),
                                Container(
                                  height: size.height * 0.18,
                                  width: size.width,
                                  decoration: const BoxDecoration(
                                      color: Colors.yellow,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/banner.png"),
                                          fit: BoxFit.fitHeight)),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        color: Colors.black54,
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            customText.kText(
                                                TextConstants.gallery,
                                                28,
                                                FontWeight.w900,
                                                Colors.white,
                                                TextAlign.center),
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: TextConstants.home,
                                                  style: customText
                                                      .kSatisfyTextStyle(
                                                          24,
                                                          FontWeight.w400,
                                                          Colors.white),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            " / ${TextConstants.gallery}",
                                                        style: customText
                                                            .kSatisfyTextStyle(
                                                                24,
                                                                FontWeight.w400,
                                                                ColorConstants
                                                                    .kPrimary))
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 15.0,
                            // crossAxisSpacing: 10.0,
                            childAspectRatio: 1 / 0.9,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            childCount: imagesList.length,
                            (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.05),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 4,
                                        color: Colors.black26)
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        imagesList[index]['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ));
  }
}
