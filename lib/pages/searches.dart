import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/search_model.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/services/search_data.dart';

class SearchNews extends StatefulWidget {
  final String searchQuery; 
  const SearchNews({required this.searchQuery});

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  List<SearchModel> searches=[];
  
  bool _loading=true;

  @override
  void initState() {
    super.initState();
    getNews(widget.searchQuery);
  }  

  void getNews(String searchQuery) async{
    showSearchNews searchNews=showSearchNews();
    await searchNews.getSearchNews(searchQuery.toLowerCase());
    searches=searchNews.searches;
    setState(() {
      _loading=false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.searchQuery,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: searches.isEmpty? Center(
          child: Text(
            "No Search results found",
            style: TextStyle(fontSize: 20),
          ),
        ) :
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: searches.length,
          itemBuilder: (context, index){
            return ShowSearch(
              image: searches[index].urlToImage!,
              desc: searches[index].description!, 
              title: searches[index].title!,
              url: searches[index].url!,
            );
          },
        ),
      ),
    );
  }
}

class ShowSearch extends StatelessWidget {
  String image, desc, title, url;
  ShowSearch({required this.image, required this.title, required this.desc, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(desc, maxLines: 3,),
            SizedBox(height: 25.0,),
          ],
        ),
      ),
    );
  }
}