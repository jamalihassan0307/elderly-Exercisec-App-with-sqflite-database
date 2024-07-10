class NavButtons {
  final int id;
  final String name;
  final String unselectImage;
  final String selectImage;

  NavButtons({
    required this.id,
    required this.name,
    required this.unselectImage,
    required this.selectImage,
  });
}

List<NavButtons> navButtons = [
  NavButtons(
    id: 0,
    name: 'Home',
    selectImage: 'assets/icons/home_fill.png',
    unselectImage: 'assets/icons/home_outline.png',
  ),
  NavButtons(
    id: 1,
    name: 'Reports',
    selectImage: 'assets/icons/report_fill.png',
    unselectImage: 'assets/icons/report_line.png',
  ),
  NavButtons(
    id: 2,
    name: 'Me',
    selectImage: 'assets/icons/user_fill.png',
    unselectImage: 'assets/icons/user_line.png',
  ),
];
