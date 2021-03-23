import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.scss'],
})
export class AboutComponent implements OnInit {
  aboutData = [
    [
      {
        icon: 'assets/images/icon1.png',
        text: 'Gym Workout',
      },
      {
        icon: 'assets/images/icon2.png',
        text: 'Yoga Workout',
      },
    ],
    [
      {
        icon: 'assets/images/icon3.png',
        text: 'Nutrition',
      },
      {
        icon: 'assets/images/icon4.png',
        text: 'Mindfulness',
      },
    ],
  ];
  constructor() {}

  ngOnInit(): void {}
}
