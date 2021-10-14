import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

cachedNetworkImage(String postUrl, bool isEditing){
  return Stack(
    children: [
      CachedNetworkImage(
        imageUrl: postUrl,
        errorWidget: (context, url, error) => Icon(Icons.error),
        placeholder: (context, url){
          return Shimmer.fromColors(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            baseColor: Colors.grey[500].withOpacity(0.1),
            highlightColor: Colors.grey[500].withOpacity(0.3),
          );
        },
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
            ),
          );
        }
      ),
      isEditing ? Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(Icons.delete_forever, color: Colors.white,)),
      ) : Text('')
    ],
  );
}

cachedNetworkImage1(String postUrl,){
  return CachedNetworkImage(
    imageUrl: postUrl,
    errorWidget: (context, url, error) => Icon(Icons.error),
    placeholder: (context, url){
      return Shimmer.fromColors(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        baseColor: Colors.grey[500].withOpacity(0.1),
        highlightColor: Colors.grey[500].withOpacity(0.3),
      );
    },
    imageBuilder: (context, imageProvider) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
        ),
      );
    }
  );
}