class ContainerWidget {
  int height;
  List<ContainerWidget>? children;
  ContainerWidget({required this.height, this.children});

  ContainerWidget build() {
    return ContainerWidget(
      height: 83, // LINT
      children: [
        ContainerWidget(
          height: 83, // LINT
        ),
      ],
    );
  }
}
