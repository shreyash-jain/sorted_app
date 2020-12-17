import { Component, OnInit } from '@angular/core';
import { OwlOptions } from 'ngx-owl-carousel-o';

@Component({
  selector: 'app-blog',
  templateUrl: './blog.component.html',
  styleUrls: ['./blog.component.scss'],
})
export class BlogComponent implements OnInit {
  customOptions: OwlOptions = {
    items: 1,
    loop: true,
    autoplay: false,
    mouseDrag: true,
    touchDrag: true,
    pullDrag: true,
    dots: true,
    navSpeed: 300,
    responsive: {
      0:{
        items: 1
      },
      480: {
        items: 1
      },
      768: {
        items: 2,
        margin: 30,
      },
      1024: {
        items: 2,
        margin: 30,
      }
    }
  };

  slidesStore = [
    {
      id: 1,
      src: 'assets/images/blog/6.jpg',
      alt: 'Image_1',
      date: '15 December 2020',
      detail: 'All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary',
      review: 'abc',
    },
    {
      id: 2,
      src: 'assets/images/blog/7.jpg',
      alt: 'Image_2',
      date: '16 december 2020',
      detail: 'All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary2',
      review: 'def',
    },
    {
      id: 3,
      src: 'assets/images/blog/8.jpg',
      alt: 'Image_3',
      date: '17 december 2020',
      detail: 'All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary3',
      review: 'ghi',
    },
    {
      id: 4,
      src: 'assets/images/blog/9.jpg',
      alt: 'Image_4',
      date: '18 december 2020',
      detail: 'All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary4',
      review: 'jkl',
    },
  ];

  constructor() {}

  ngOnInit(): void {}
}
