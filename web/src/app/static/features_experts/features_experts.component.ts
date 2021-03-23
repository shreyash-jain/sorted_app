import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-features-experts',
  templateUrl: './features_experts.component.html',
  styleUrls: ['./features_experts.component.scss'],
})
export class FeaturesExpertsComponent implements OnInit {
  featuresData = [
    [
      {
        icon: 'assets/images/icon/4.png',
        subtitle: 'Weight Loss Training',
        subText:
          '',
      },
      {
        icon: 'assets/images/icon/1.png',
        subtitle: 'Cardio workout',
        subText:
          '',
      },
      {
        icon: 'assets/images/icon/4.png',
        subtitle: 'Weight Training',
        subText:
          '',
      },
     
      // {
      //   icon: 'assets/images/icon/5.png',
      //   subtitle: 'Unlimited Features',
      //   subText:
      //     'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      // },
    ],
    [
      
     
      // {
      //   icon: 'assets/images/icon/6.png',
      //   subtitle: '24 x 7 Support',
      //   subText:
      //     'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      // },
    ],
  ];

  constructor() {}

  ngOnInit(): void {}
}
