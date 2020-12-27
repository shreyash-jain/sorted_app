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
      name: 'Anonymous',
      role: 'Developer',
      content:
        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.Contrary to popular belief, Lorem Ipsum is not simply random text.',
    },
    {
      id: 2,
      image: 'assets/images/avatar/1.png',
      name: 'Anonymous',
      role: 'Doctor',
      content:
        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.Contrary to popular belief, Lorem Ipsum is not simply random text.',
    },
    {
      id: 3,
      image: 'assets/images/avatar/1.png',
      name: 'Anonymous',
      role: 'Designer',
      content:
        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.Contrary to popular belief, Lorem Ipsum is not simply random text.',
    },
  ];
  constructor() {}

  ngOnInit(): void {}
}
