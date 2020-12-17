import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-features',
  templateUrl: './features.component.html',
  styleUrls: ['./features.component.scss'],
})
export class FeaturesComponent implements OnInit {
  featuresData = [
    [
      {
        icon: 'assets/images/icon/1.png',
        subtitle: 'User Friendly',
        subText:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      },
      {
        icon: 'assets/images/icon/3.png',
        subtitle: 'High Performance',
        subText:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      },
      {
        icon: 'assets/images/icon/5.png',
        subtitle: 'Unlimited Features',
        subText:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      },
    ],
    [
      {
        icon: 'assets/images/icon/2.png',
        subtitle: 'Quick Update',
        subText:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      },
      {
        icon: 'assets/images/icon/4.png',
        subtitle: '100% secure',
        subText:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      },
      {
        icon: 'assets/images/icon/6.png',
        subtitle: '24 x 7 Support',
        subText:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      },
    ],
  ];

  constructor() {}

  ngOnInit(): void {}
}
