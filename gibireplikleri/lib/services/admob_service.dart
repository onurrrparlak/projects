import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {

   void Function(String message)? rewardedAdNotReadyCallback;

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6463656772430340/8565172142'
      : 'ca-app-pub-6463656772430340/8565172142';
  String get rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6463656772430340/5192123096' // test ad unit id
      : 'ca-app-pub-6463656772430340/5192123096';

  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;
   Function()? adDismissedCallback;

  

  void initialize() {
    createBannerAd();
    createRewardedAd();
    
  
  }

  

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          
         if (adDismissedCallback != null) {
          adDismissedCallback!(); // Invoke the callback when ad is dismissed
        }
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          
        },
      );
    } else {
     if (rewardedAdNotReadyCallback != null) {
        rewardedAdNotReadyCallback!("Reklam henüz hazır değil. Lütfen bekleyiniz ve internet bağlantınızı kontrol ediniz. Reklam engelleyici kullanmadığınızdan emin olunuz"); // Pass the message to the callback
      }
    }
  }



  void createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => ('Ad loaded'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  Widget showBannerAd() {
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
