import { Component, OnInit } from '@angular/core';
import { OwlOptions } from 'ngx-owl-carousel-o';

@Component({
  selector: 'app-screenshot',
  templateUrl: './screenshot.component.html',
  styleUrls: ['./screenshot.component.scss']
})
export class ScreenshotComponent implements OnInit {

  customOptions: OwlOptions = {
    items: 1,
    loop: true,
    autoplay: true,
    autoplaySpeed: 800,
    mouseDrag: true,
    touchDrag: true,
    pullDrag: true,
    dots: false,
    center: true,
    navSpeed: 300,
    margin: 30,
    responsive: {
      0: {
        items: 2 
      },
      480: {
        items: 2
      },
      768: {
        items: 3
      },
      1024: {
        items: 4
      }
    }
  };

  slidesStore = [
    {
      id: 1,
      image: 'assets/images/app/1.jpg',
    },
    {
      id: 2,
      image: 'assets/images/app/2.jpg',
    },
    {
      id: 3,
      image: 'assets/images/app/3.jpg',
    },
    {
      id: 4,
      image: 'assets/images/app/4.jpg',
    },
    {
      id: 5,
      image: 'assets/images/app/5.jpg',
    },
    {
      id: 6,
      image: 'assets/images/app/6.jpg',
    },
    {
      id: 7,
      image: 'assets/images/app/7.jpg',
    },
    {
      id: 8,
      image: 'assets/images/app/8.jpg',
    },
    {
      id: 9,
      image: 'assets/images/app/9.jpg',
    },
    {
      id: 10,
      image: 'assets/images/app/10.jpg',
    },
    {
      id: 11,
      image: 'assets/images/app/11.jpg',
    },
    {
      id: 12,
      image: 'assets/images/app/12.jpg',
    },
  ];
  constructor() { }

  ngOnInit(): void {
  }

}
