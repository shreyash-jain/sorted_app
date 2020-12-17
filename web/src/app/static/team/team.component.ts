import { Component, OnInit } from '@angular/core';
import { OwlOptions } from 'ngx-owl-carousel-o';

@Component({
  selector: 'app-team',
  templateUrl: './team.component.html',
  styleUrls: ['./team.component.scss'],
})
export class TeamComponent implements OnInit {
  customOptions: OwlOptions = {
    items: 1,
    loop: true,
    autoplay: false,
    mouseDrag: true,
    touchDrag: true,
    pullDrag: true,
    dots: true,
    center: true,
    navSpeed: 300,

    responsive: {
      0: {
        items: 1,
        margin: 5,
      },
      480: {
        items: 1,
        margin: 5,
      },
      768: {
        items: 2,
        margin: 30,
      },
      1024: {
        items: 3,
        margin: 30,
      },
    },
  };

  slidesStore = [
    {
      id: 1,
      avtar: 'assets/images/avatar/1.jpg',
      name: 'abc def',
      role: 'developer'
    },
    {
      id: 2,
      avtar: 'assets/images/avatar/15.jpg',
      name: 'sjd ahef',
      role: 'qkjkejf'
    },
    {
      id: 3,
      avtar: 'assets/images/avatar/22.jpg',
      name: 'qjhflewhf',
      role: 'kjheflwehf'
    },
    {
      id: 1,
      avtar: 'assets/images/avatar/1.jpg',
      name: 'ahdioewjf',
      role: 'mfnlkwe'
    },
    {
      id: 1,
      avtar: 'assets/images/avatar/15.jpg',
      name: 'kjvlkdnvklwn',
      role: 'efjkhwek'
    },
  ];
  constructor() {}

  ngOnInit(): void {}
}
