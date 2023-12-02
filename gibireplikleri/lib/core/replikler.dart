import 'package:flutter/material.dart';

class Replikler extends StatelessWidget {
  const Replikler({super.key});

// Söyleyenler: 0 = Yılmaz, 1 = İlkkan, 2 = Ersoy
  static List<Map<String, dynamic>> replikler = [
    {
      'id': 0,
      'replik':
          'Kardeşim ben senin yılgın bir hoş görüyle beni benimsemene mi kaldım',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 1,
      'replik':
          'Kimsenin hiçbir şey bilmediği yerde bir insan her şeyi bilebilir bu kadar yani',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 2,
      'replik':
          'Avcı ne kadar hile bilirse, Ayı da o kadar yol bilir. Anlaşıldı kukiciğim',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 3,
      'replik': 'Bize hiçbir şey nasip olmuyor ya!',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 4,
      'replik':
          'İlkkan bizim senle sırt sırta veripte sikemeceyeğimiz insan yok ben buna inanıyorum kardeşim',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 5,
      'replik':
          'Lan yaşadığımız yetmiyor bir de senden dinliyoruz hayatın acı gerçeklerini',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 6,
      'replik':
          'İlkkan sadece 10 liramın olması, 0 liramın olmasından daha çok canımı yakıyor',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 7,
      'replik':
          'Uzatma kardeşim şurda suskun prensin öpücüğünü sokmayayım ağzına',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 8,
      'replik':
          'Gerçeklerin bir kıymeti yok ki Ercan abi genel kanı neyse onu yaşıyoruz yani, zaten',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 9,
      'replik':
          'Ben senin gözlerinin içine bakıyorum ve göt deliğini kardeşim. O kadar şeffafsın sen bana',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 10,
      'replik':
          'Ya güzel kardeşim bir şeyin tam tersini söyle al sana farklı bakış açısı',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 11,
      'replik': 'Ayben ne lan? Sen Ibana, Ayben mi diyon?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 12,
      'replik': 'Abi yahşı günde yar yahşıdır yaman günde yetiş gardaş',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 13,
      'replik': 'El vardır ele olur el, bel vardır bele olur bel..',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 14,
      'replik':
          'Hiç mi anlamadın oğlum insan bilir ne yaşadığını ya. Yaşarken anlamadın mı sen ne kadar yaşadığını?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 15,
      'replik':
          'Ben yanlış geldiğimi anladım, siz çok yanlış gözüküyorsunuz ben o manada',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 16,
      'replik':
          'En temel üç unsurdan bahsediyorum. 1 - Saygı, 2 - Saygı, 3 - Saygı',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 17,
      'replik': 'Herzekar ağız başa yumruk vurdurar',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 18,
      'replik': 'Mustafa abi beni dövdü dese anlarım',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 19,
      'replik': 'Takla attıysa olmaz abi',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 20,
      'replik':
          '10 bine hemen bu aracı burda terk edip giderim. Sonra ama geri gelirsin satış işlemleri, noter falan?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 21,
      'replik':
          'Ayrıca benim zevklerim sizin nezdinizde makul bir zemine oturmak zorunda da değil',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 22,
      'replik': 'Gittin de oraya mı gittin yani?',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 23,
      'replik': 'Yav Erdem atletik diye ben neden köfteci açmak zorundayım ya?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 24,
      'replik': 'Sağlıklı insanın birazda sevilmemesi gerekiyor kardeşim. ',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 25,
      'replik': 'Saat daha sabah 8. Büyücüler açılmamıştır ',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 26,
      'replik':
          'Karanlık, kadim, kötücül bir güç uyanırda bize zarar verirse diye gofret aldık ',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 27,
      'replik':
          'Bir dedi ateş toplarının zırh mızrakları var dedi neyse işte o, bir de dedi sessiz laboratuvarın hırsızı var dedi ',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 28,
      'replik':
          'Köstebek gidiyor tütüncülere: Ey Tütüncüler hayırdır köstebek? Tütünde misiniz? ',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 29,
      'replik':
          'Amcacım zaten tanıyınca o normal misafir oluyor. Bu tanrı misafiri zaten bu konsept yani, tanımıyor olunca ',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 30,
      'replik': 'Allahın dinlenme tesisinde bu ne sembolizm ya böyle ',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 31,
      'replik': 'İlkkan yani seni hiç dinlemedim ama yani bence haksızsın ya',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 32,
      'replik':
          'Ben zaten bir tek seni tanıyorum İlkkan, haksızlığa dayanamayan',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 33,
      'replik': 'Abi zaman nedir?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 34,
      'replik': 'Püh senin ben ananı sikeyim orospu çocuğuna bak be',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 35,
      'replik': 'Sendeki bu güç hevesi bizim ağzımıza sıçtı',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 36,
      'replik': 'Ya ben hayattan bir tek şey istedim ya',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 37,
      'replik': 'Bak sen şu kukinin dediklerine bak ya',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 38,
      'replik': 'Olgaç siktir git 15 yıl daha gözükme gözüme',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 39,
      'replik':
          'İlkkan bu rumbanın mamboya da o kadar etkisi olduğunu ben sanmıyorum ya',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 40,
      'replik':
          'Ya Ersoyum evet, işte yayla kadar götüm olsa tek çobanım sen olmazdın',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 41,
      'replik':
          'Bir gün önce babaannesi yenen hiç kimse ertesi gün kahvaltıcıya gitti diye kafası dağılmaz',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 42,
      'replik':
          'Bizler sorunlarımızdan kahvaltı yaparak kaçan insanlar da değiliz',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 43,
      'replik':
          'Ama ben bir kahve içiyim abi, kahve içmeden sabahları kendime gelemiyorum ben',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 44,
      'replik': 'Siz böylesiniz işte sizin gerçeklere alerjiniz var',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 45,
      'replik':
          'Lovebombing, gaslighting, ghosting nihayetinde de işte kara toprak',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 46,
      'replik': 'Yılmaz! Madalyamı ver!',
      'soyleyen': 1,
      'kufur': true,
    },
    {
      'id': 47,
      'replik':
          'Hiçbir zaman insanın kafasında böyle yekpare kristal top gibi parlayan tek bir düşünce olmuyor.',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 48,
      'replik': 'Ya her şey için çok uğraşıyoruz ya, valla bıktım ama ya',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 49,
      'replik':
          'Hayat böyle küçük detaylarıyla, minik sürprizleriyle ve heyecanıyla anlam kazanıyor',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 50,
      'replik': 'Abi iyilik yap at denize',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 51,
      'replik': 'Oğlum sen hala köle misin? Kurtuldun ya, biz siviliz lan',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 52,
      'replik':
          'Ay canım benim ya, sen psikiyatrist misin? Sen psikolog musun?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 53,
      'replik': 'Al şimdi masküleniteni sok götüne kardeşim. Ben sana ne dedim',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 54,
      'replik':
          'İnsanı seçeneksiz bırakıyorlar, vallahi bak ben seçeneksiz hissediyorum şuan da kendimi',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 55,
      'replik': 'Ulan asıl sana yuh be. Sokaktan mı topluyorum ben böbrekleri?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 56,
      'replik': 'Benim evim burası, bu evin efendisiyim ben',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 57,
      'replik':
          'Bu arada Ersoyum, ben sevgiye açılan küçük geçitler değil devasa, köprüler görürüm',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 58,
      'replik': 'Bana Baba desene ya bi Cengiz',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 59,
      'replik':
          'Bu gece ben yattığım yeri beğenirim işte. Bu gece var ya bu gece uyuyacaz işte o belli oldu',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 60,
      'replik':
          'Hayat arzularımızı ve beklentilerimizi her zaman karşılamıyor Onur',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 61,
      'replik': 'Ersoy orta okula gittin dimi sen? Kümeleri anlatmışlardır',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 62,
      'replik':
          'İnsanlar o kadar aptal ki ya. Çok aptallar ya. Yani Allah kahretsin hepsini',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 63,
      'replik': 'Yürümek öyle çokta matah bir şey değil Ozan',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 64,
      'replik':
          'İyi geceler yazmamışım. Gece neden yatarken iyi geceler yazmadın',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 65,
      'replik': 'Sen istediğin kadar oku, var olamazsın',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 66,
      'replik': 'Siz siktirin gidin lan ne diyosunuz adamın acısı var burda',
      'soyleyen': 1,
      'kufur': true,
    },
    {
      'id': 67,
      'replik': 'Bütün kadınlarla aynı fikirdesin ya',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 68,
      'replik': 'Bu bize açım dedi mi, dedi abi, biz güldük mü , güldük',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 69,
      'replik': 'Ya gelin kalın ya da siktirin gidin',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 70,
      'replik': 'Halı çalan adamdan her şey beklenir',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 71,
      'replik':
          'İlkkan sen bu sefer ne kadar geciktin ya Esraya katılmakta normalde zart diye katılman lazım senin',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 72,
      'replik':
          'Dikkat edin ne kardeşim ya. Ne uyarı mı nasihat mı tehdit mi bu ne ya?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 73,
      'replik':
          'Kalabalık dediğin 10 kişiyiz burda. Bir de belki çoğalacağız ilerde',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 74,
      'replik':
          'Ortalama bir gelire sahip olup, vasat bir kadınla evlenmek bence',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 75,
      'replik':
          'İlkkan sen hayırdır ne oldu sana bir kaç gündür kangal köpeği gibisin. Seni kapıya bağlarım ha',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 76,
      'replik':
          'Sadece küçük insanlar küçük şeyler için büyük fırtınalar kopartır',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 77,
      'replik': 'İlkbaharda usul usul yürü, toprak ana hamiledir',
      'soyleyen': 1,
      'kufur': true,
    },
    {
      'id': 78,
      'replik':
          'Ben böyle sizin gibi sikimin peşine düşüpte sahte yaşam tarzları edinemiyorum bir anda',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 79,
      'replik': 'Ben dişisi olmayan tek hayvan tanıyorum o da sen',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 80,
      'replik':
          'Gittim sordum abi çeyrek altının altı ne oluyor dedim, gram altın dediler',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 81,
      'replik': 'Kesin seks yapıyor bu pezevenk. Seks nabzı bu',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 82,
      'replik':
          'Her kim ki biner ellerin sıtkına, elbet düşer milletin rıkkına',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 83,
      'replik': 'Senin ben dilini damağını sikiyim be Yılmaz',
      'soyleyen': 1,
      'kufur': true,
    },
    {
      'id': 84,
      'replik': 'İlkkan yani sen ışıl ışıl bir dallamasın lan',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 85,
      'replik': 'Cosplay pahalı bir zevk, hata kaldırmaz',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 86,
      'replik': 'Ya içini ayrı sikeyim dışını ayrı sikeyim senin ya',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 87,
      'replik': 'Düzgün konuş kimse benim dostlarımı sikemez',
      'soyleyen': 1,
      'kufur': true,
    },
    {
      'id': 88,
      'replik': 'Bunlara bu parayı veren kendi götünü de siker',
      'soyleyen': 2,
      'kufur': true,
    },
    {
      'id': 89,
      'replik': 'Sıcak suya kola damlattım',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 90,
      'replik': 'Tercihim belli, Libido',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 91,
      'replik':
          'Ersoy bir süredir çok çıplaksın, hiç beklemediğin bir anda böyle şak diye tokat atacağım sana',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 92,
      'replik': 'Sen dikkat et sen çok hayal perestsin',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 93,
      'replik':
          'Cesaret ettin denedin olmadı bi daha denersin daha iyi olmaz yani',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 94,
      'replik':
          'Şeker kullanan birisinin verdiği akla ben nasıl inanayım zaten',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 95,
      'replik': 'Çay var? İçin. Sende iç? Yok ben içmeyeceğim',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 96,
      'replik': 'Yalan mı lan? Köle değil misin?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 97,
      'replik': 'Boşta çatal yok, bütün çatallar aktif',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 98,
      'replik': 'Bu kız için cosplay yapılır kardeşim nokta',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 99,
      'replik': 'Evet boğa burcu, çok nadir rastladığımız bir burç boğa burcu',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 100,
      'replik':
          'Geçip giden günlerin en belirgin özelliği ne? Bunların geçip gitmesi',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 101,
      'replik': 'Ücretimi ödeyeceksiniz ya benim? Kölelik yevmiyemi?',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 102,
      'replik':
          'Ersoy bak berbat bir insanla arkadaşız ve onu sevmeye mahkum edilmişiz gibi',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 103,
      'replik':
          'Yılmaz, beni küçültme. Şu an çok büyüğüm lan şarap falan içiyorum bak',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 104,
      'replik':
          'Yine gittin bütün paranla en pahalı içeceği aldın. Sen kimsin oğlum ya?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 105,
      'replik': 'İlkkan bunun çok kısa, tek kelimelik cevabı var. Sanane?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 106,
      'replik': 'Kanımı sattım yılmaz, kan sattım.',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 107,
      'replik':
          'Ulan bak kraliçeyle özel görüşme dedin, sikmeye geldik sandılar.',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 108,
      'replik': 'Büyülü müdür nedir amına koduğumun yeri',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 109,
      'replik': 'Boşuna dememişler abi, deveden büyük fil var',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 110,
      'replik': 'Ben senin aksine, bir bireyim. Benim bir karakterim var',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 111,
      'replik':
          'Bayanla mı konuşuyorsun? Canlılarla mı konuşuyorsun çok daha geniş bir kümede?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 112,
      'replik': 'O zaman bir şöbiyet yer miyiz?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 113,
      'replik':
          'Vallahi Ümran abla ne desen haklısın şimdi. Hiç hesapta olmayana bir kölelik durumu çıktı',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 114,
      'replik': 'Ben senin hakkında çok kritik 2 yeni bilgiye sahibim',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 115,
      'replik': 'Lan sikik',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 116,
      'replik': 'Ne kadar korkaksın ya? Korkak değilim abi, gerçekçiyim.',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 117,
      'replik':
          'Senin bu tişörtün sahte lan. Lan sen ne utanmaz adamsın lan Ersoy',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 118,
      'replik': 'Sen makyaj mı yapıyorsun?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 119,
      'replik': 'Bu yumurtalar sayılı mı ya?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 120,
      'replik': 'Abi Tanrıyı güldürmek istiyorsan, ona planlarından bahset',
      'soyleyen': 1,
      'kufur': true,
    },
    {
      'id': 121,
      'replik': 'Lan ben adapteyim adapte',
      'soyleyen': 1,
      'kufur': false,
    },
    {
      'id': 122,
      'replik': 'Poetic justice. Biliyor musun ne demek? Şiirsel adalet demek',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 123,
      'replik': 'Düdük mü çalacan dark lorda?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 124,
      'replik': 'Sende Çaça var mı? Nolur var de.',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 125,
      'replik': 'Siyah tazı emzirmek, maddi sıkıntı demekmiş',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 126,
      'replik': 'İlkkan senin ben geçmişini sikiyim',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 127,
      'replik': 'Saçını sakalını uzattın şaman mı oldun?',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 128,
      'replik': 'Bayağı da yemiş orospu çocuğu',
      'soyleyen': 1,
      'kufur': true,
    },
    {
      'id': 129,
      'replik': 'Bir de siktiler mi acaba dedim',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 130,
      'replik':
          'Arkadaşlar da kalkacak mısınız? Öyle bir bakış var gibi gözlerde',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 131,
      'replik':
          'En büyüksün sen. Alfasın sen. Sürü liderisin. Sen de ki bu persona.. - Siktir lan',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 132,
      'replik': 'Lütfen telefon açıp anasına söver misin İlkkanın?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 133,
      'replik': 'Ulan arkadaşımız sikiliyor',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 134,
      'replik': 'Ersoy, bir baksana İlkkan mutlu mu?',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 135,
      'replik': 'Kafanın şekli çok kötü',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 136,
      'replik':
          'Canım benim senin tarzın yok. Seni özel birisi yapan bu zaten, tarzının olmayışı',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 137,
      'replik':
          'Bu zamana kadar benim ağzımdan bir tane güzel söz duymadıysanız bunun da sebebi benim sadece doğruları, gerçekleri söylememdir.',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 138,
      'replik':
          'Ayrıca mesaj attığı son 5 kadın geri dönmemiş mesajına. Aktif bir çalışma yok yani',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 139,
      'replik':
          'Ne zaman ki İlkkan sikildiğini anlayacak hale gelecek, işte biz senle onu sikeceğiz.',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 140,
      'replik': 'O paranın 2 bin tlsi bana ait',
      'soyleyen': 2,
      'kufur': false,
    },
    {
      'id': 141,
      'replik': 'Sen sik satan bir köpeksin',
      'soyleyen': 0,
      'kufur': true,
    },
    {
      'id': 142,
      'replik': 'Süreçte hiç yoksun, sürece gel.',
      'soyleyen': 0,
      'kufur': false,
    },
    {
      'id': 143,
      'replik': 'Hayırdır Tanjucuğum, grup mu var?',
      'soyleyen': 0,
      'kufur': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
