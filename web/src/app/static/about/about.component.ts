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
        text: 'Easy to Customize',
      },
      {
        icon: 'assets/images/icon3.png',
        text: 'Easy to Use',
      },
    ],
    [
      {
        icon: 'assets/images/icon2.png',
        text: 'Nice Design',
      },
      {
        icon: 'assets/images/icon4.png',
        text: 'SEO Friendly',
      },
    ],
  ];
  constructor() {}

  ngOnInit(): void {}
}
