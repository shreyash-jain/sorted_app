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
        text: 'Health',
      },
      {
        icon: 'assets/images/icon2.png',
        text: 'Self-Improvement',
      },
    ],
    [
      {
        icon: 'assets/images/icon3.png',
        text: 'Nutrition',
      },
      {
        icon: 'assets/images/icon4.png',
        text: 'Productivity',
      },
    ],
  ];
  constructor() {}

  ngOnInit(): void {}
}
