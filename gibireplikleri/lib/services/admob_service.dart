import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';
  String get rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-6463656772430340/5800139246' // test ad unit id
      : 'ca-app-pub-6463656772430340/5800139246';

  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;

  bool _canShowRewardedAd = true;

  void initialize() {
    createBannerAd();
    createRewardedAd();
    startRewardedAdTimer();
  }

  void startRewardedAdTimer() {
    Timer(const Duration(seconds: 5), () {
      if (_canShowRewardedAd) {
        showRewardedAd();
      }
    });
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          _canShowRewardedAd = false;
          startAdCooldownTimer();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
          print('Failed to show rewarded ad: $error');
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print('User earned reward: ${reward.amount}');
          // TODO: Implement reward functionality
        },
      );
    } else {
      print('Rewarded ad is not ready.');
    }
  }

  void startAdCooldownTimer() {
    Timer(const Duration(hours: 12), () {
      _canShowRewardedAd = true;
    });
  }

  void createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Ad loaded'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
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
