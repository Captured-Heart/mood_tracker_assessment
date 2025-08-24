enum AppImages {
  moodAwesome('mood_awesome'),
  moodGood('mood_good'),
  moodHorrible('mood_horrible'),
  moodSad('mood_sad'),
  loginBackground('login_bg'),
  coin('coin'),
  coinBag('coin_bag'),
  rewardBackground('reward_bg'),
  sadFace('sad_face'),
  happyFace('happy_face'),
  noImageAvatar('no_image_avatar'),
  appLogo('app_logo');

  const AppImages(this.imageName);
  final String imageName;

  String get pngPath => 'assets/images/png/$imageName.png';
}
