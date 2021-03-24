import { Component, OnInit } from '@angular/core';
import { OwlOptions } from 'ngx-owl-carousel-o';

@Component({
  selector: 'app-testimonial',
  templateUrl: './testimonial.component.html',
  styleUrls: ['./testimonial.component.scss'],
})
export class TestimonialComponent implements OnInit {
  customOptions: OwlOptions = {
    items: 1,
    loop: true,
    autoplay: false,
    mouseDrag: true,
    touchDrag: true,
    pullDrag: true,
    dots: false,
    center: true,
    navSpeed: 700,
    margin: 5,
    responsive: {
      0: {
        items: 1,
      },
      480: {
        items: 1,
      },
      768: {
        items: 1,
      },
      1024: {
        items: 1,
      },
    },
    navText: [
      '<img src="assets/images/back.png"/>',
      '<img src="assets/images/next.png"/>',
    ],
  };

  slidesStore = [
    {
      id: 1,
      image: 'assets/images/avatar/1.png',
      name: 'Mukul Bajpai',
      role: 'Weight Loss workout',
      content:
        'I enjoyed my 12 week journey with Sort.it.. Not only did I lose weight and inches, this journey changed my eating habits too! What’s more, I’ve become regular at the gym which was something I’ve always struggled with.',
    },
    {
      id: 2,
      image: 'assets/images/avatar/1.png',
      name: 'Abhilash Pawar',
      role: 'Weight Loss workout',
      content:
        'Since I started my journey with Sort.it, I have lost 8kgs and lot of inches in a short span of time. I never thought of losing so much belly fat in this time frame.',
    },
    {
      id: 3,
      image: 'assets/images/avatar/1.png',
      name: 'Sushma Chaudhary',
      role: 'Stay Fit program',
      content:
        'The best community if you are looking for a healthy and sustainable lifestyle. Join today for a better tomorrow!!',
    },
  ];
  constructor() {}

  ngOnInit(): void {}
}
