import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/pages/all_news.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/pages/category_news.dart';
import 'package:news_app/pages/searches.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories =[];
  List<sliderModel> sliders=[];
  List<ArticleModel> articles = [];
  bool _loading=true;

  int activeIndex=0;
  @override
  void initState() {
    categories = getCategories();
    getSlider();
    getNews();
    super.initState();
  }

  // To get all news saved in the news.dart file
  getNews() async{
    News newsClass=News();
    await newsClass.getNews();
    articles=newsClass.news;
    setState(() {
      _loading=false; //Once we get all the news, make loading false
    });
  }

  // Get slider carousel data
  getSlider() async{
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders=slider.sliders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search), // Add magnifying icon
                ),
                onSubmitted:(query) {
                  Navigator. push(context, MaterialPageRoute(builder: (context)=>SearchNews(searchQuery: query)));
                },
              ),
            ),
            Row(
              children: [
                Text("BallAd's "),
                Text(
                  "Bulletin",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading? Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category 
              Container(
                margin: EdgeInsets.only(left: 10.0), //Provide some margin to the first image
                height: 70,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal, //Display images horizontally
                  itemCount: categories.length,
                  itemBuilder: (context, index){
                    return CategoryTile(
                      image: categories[index].image,
                      categoryName: categories[index].categoryName,
                    );
                  }
                ),
              ),
        
              // Space between sections
              SizedBox(
                height: 30.0,
              ),
        
              // BREAKING NEWS
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Breaking News!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'BlackOpsOne',
                      ),
                    ),
                    GestureDetector(
                      onTap:() {
                       Navigator. push(context, MaterialPageRoute(builder: (context)=>AllNews(news: "Breaking")));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // CAROUSEL SLIDER
              CarouselSlider.builder(
                itemCount: 5,
                itemBuilder: (context, index, realIndex){
                  String? res= sliders[index].urlToImage;
                  String? res1= sliders[index].title;
                  String? res2=sliders[index].url;
                  return buildImage(res!, index, res1!, res2!);
                },
                options: CarouselOptions(
                  height: 250,
                  //viewportFraction: 1, //Show one image at a time
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason){
                    setState(() {
                      activeIndex= index;
                    });
                  },
                ),
              ),
              SizedBox(height: 30.0,),
        
              Center(child: buildIndicator()),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trending News!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'BlackOpsOne'
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                       Navigator. push(context, MaterialPageRoute(builder: (context)=>AllNews(news: "Trending")));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index){
                    return BlogTile(
                      url: articles[index].url!,
                      desc: articles[index].description!, 
                      imageUrl: articles[index].urlToImage!, 
                      title: articles[index].title!,
                    );
                  },
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
  // Carousel build image
  Widget buildImage(String image, int index, String name, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url) ));
      },
      child: Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0), //Space between images
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: image, 
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 250,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            height: 250,
            padding: EdgeInsets.only(
              left: 10.0
            ),
            margin: EdgeInsets.only(
              top: 170.0,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            ),
            child: Text(
              name,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]
      ),
        ),
    );
}

  Widget buildIndicator()=> AnimatedSmoothIndicator(
    activeIndex: activeIndex, 
    count: 5,
    effect: JumpingDotEffect(
      dotWidth: 15,
      dotHeight: 15,
      activeDotColor: const Color.fromARGB(255, 94, 17, 12),
    ),
  );
}

// List of categories
class CategoryTile extends StatelessWidget {
  final image, categoryName; //Pass image and category name here
  CategoryTile({this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16), //Provide margin
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image, 
                width: 120, 
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  String imageUrl, title, desc, url;
  BlogTile({required this.desc, required this.imageUrl, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url) ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover
                      ),
                    )
                  ),
                  SizedBox(width: 8.0,),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/1.8,
                        child: Text(
                            title,
                            maxLines: 2,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/1.8,
                        child: Text(
                            desc, //Description
                            maxLines: 3,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),   
          ),
        ),
      ),
    );
  }
}

/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/pages/all_news.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/pages/category_news.dart';
import 'package:news_app/pages/searches.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories =[];
  List<sliderModel> sliders=[];
  List<ArticleModel> articles = [];
  bool _loading=true;

  int activeIndex=0;
  @override
  void initState() {
    categories = getCategories();
    getSlider();
    getNews();
    super.initState();
  }

  // To get all news saved in the news.dart file
  getNews() async{
    News newsClass=News();
    await newsClass.getNews();
    articles=newsClass.news;
    setState(() {
      _loading=false; //Once we get all the news, make loading false
    });
  }

  // Get slider carousel data
  getSlider() async{
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders=slider.sliders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("BallAd's "),
                Text(
                  "Bulletin",
                  style: TextStyle(color: Color.fromARGB(255, 230, 15, 12), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      
      body: _loading? Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search), // Add magnifying icon
                ),
                onSubmitted:(query) {
                  Navigator. push(context, MaterialPageRoute(builder: (context)=>SearchNews(searchQuery: query)));
                },
              ),
              SizedBox(
                height: 20,
              ),
              // Category 
              Container(
                margin: EdgeInsets.only(left: 10.0), //Provide some margin to the first image
                height: 70,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal, //Display images horizontally
                  itemCount: categories.length,
                  itemBuilder: (context, index){
                    return CategoryTile(
                      image: categories[index].image,
                      categoryName: categories[index].categoryName,
                    );
                  },
                ),
              ),
        
              // Space between sections
              SizedBox(
                height: 30.0,
              ),
        
              // BREAKING NEWS
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Breaking News!",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'BlackOpsOne',
                      ),
                    ),
                    GestureDetector(
                      onTap:() {
                       Navigator. push(context, MaterialPageRoute(builder: (context)=>AllNews(news: "Breaking")));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // CAROUSEL SLIDER
              CarouselSlider.builder(
                itemCount: 5,
                itemBuilder: (context, index, realIndex){
                  String? res= sliders[index].urlToImage;
                  String? res1= sliders[index].title;
                  String? res2=sliders[index].url;
                  return buildImage(res!, index, res1!, res2!);
                },
                options: CarouselOptions(
                  height: 250,
                  //viewportFraction: 1, //Show one image at a time
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason){
                    setState(() {
                      activeIndex= index;
                    });
                  },
                ),
              ),
              SizedBox(height: 30.0,),
        
              Center(child: buildIndicator()),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trending News!",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'BlackOpsOne'
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                       Navigator. push(context, MaterialPageRoute(builder: (context)=>AllNews(news: "Trending")));
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index){
                    return BlogTile(
                      url: articles[index].url!,
                      desc: articles[index].description!, 
                      imageUrl: articles[index].urlToImage!, 
                      title: articles[index].title!,
                    );
                  },
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
  // Carousel build image
  Widget buildImage(String image, int index, String name, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url) ));
      },
      child: Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0), //Space between images
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: image, 
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 250,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            height: 250,
            padding: EdgeInsets.only(
              left: 10.0
            ),
            margin: EdgeInsets.only(
              top: 170.0,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            ),
            child: Text(
              name,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]
      ),
        ),
    );
}

  Widget buildIndicator()=> AnimatedSmoothIndicator(
    activeIndex: activeIndex, 
    count: 5,
    effect: JumpingDotEffect(
      dotWidth: 15,
      dotHeight: 15,
      activeDotColor: const Color.fromARGB(255, 94, 17, 12),
    ),
  );
}

// List of categories
class CategoryTile extends StatelessWidget {
  final image, categoryName; //Pass image and category name here
  CategoryTile({this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16), //Provide margin
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image, 
                width: 120, 
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  String imageUrl, title, desc, url;
  BlogTile({required this.desc, required this.imageUrl, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url) ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover
                      ),
                    )
                  ),
                  SizedBox(width: 8.0,),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/1.8,
                        child: Text(
                            title,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/1.8,
                        child: Text(
                            desc, //Description
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),   
          ),
        ),
      ),
    );
  }
}
*/