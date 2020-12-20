import { Component, OnInit } from '@angular/core';
import { OwlOptions } from 'ngx-owl-carousel-o';

@Component({
  selector: 'app-price',
  templateUrl: './price.component.html',
  styleUrls: ['./price.component.scss'],
})
export class PriceComponent implements OnInit {
  customOptions: OwlOptions = {
    items: 1,
    loop: true,
    autoplay: false,
    mouseDrag: true,
    touchDrag: true,
    pullDrag: true,
    dots: true,
    center: true,
    navSpeed: 700,
    responsive: {
      0: {
        items: 1,
      },
      480: {
        items: 1,
      },
      768: {
        items: 2,
        margin: 30,
        center: false,
        dots: false,
        mouseDrag: true,
        touchDrag: true,
        pullDrag: true,
      },
      1024: {
        items: 2,
        margin: 30,
        dots: false,
        center: false,
        mouseDrag: true,
        touchDrag: true,
        pullDrag: true,
      },
    },
  };

  slidesStore = [
    {
      id: 1,
      type: 'Basic',
      userType: 'Only Basic Features',
      mrp: '$50',
      duration: 'per year',
      features: ['abc', 'def', 'ghi', 'jkl', 'xyz'],
    },
    {
      id: 2,
      type: 'Standard',
      userType: 'Take it to next level',
      mrp: '$100',
      duration: 'per year',
      features: ['abc', 'def', 'ghi', 'jkl', 'xyz'],
    },
    {
      id: 3,
      type: 'Custom',
      userType: 'Our biggest plan',
      mrp: '$150',
      duration: 'per year',
      features: ['abc', 'def', 'ghi', 'jkl', 'xyz'],
    },
  ];
  constructor() {}

  ngOnInit(): void {}
}
