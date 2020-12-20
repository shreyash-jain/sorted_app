import { Component, HostListener, OnInit } from '@angular/core';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
})
export class HeaderComponent implements OnInit {
  public isScrolled: boolean = false;
  @HostListener('window:scroll', ['$event']) onScrollEvent($event) {
    this.isScrolled = $event.target['scrollingElement'].scrollTop > 0;
  }
  public menu: boolean;

  menuItems = [
    {
      name: 'Home',
      link: '#home',
    },
    {
      name: 'about',
      link: '#about',
    },
    {
      name: 'Feature',
      link: '#features',
    },
    // {
    //   name: 'team',
    //   link: '#team',
    // },
    // {
    //   name: 'blog',
    //   link: '#blog',
    // },
    // {
    //   name: 'price',
    //   link: '#price',
    // },
    {
      name: 'testimonials',
      link: '#testimonial',
    },
    {
      name: 'contact Us',
      link: '#contact',
    },
  ];

  constructor() {}

  ngOnInit(): void {
    this.menu = false;
  }

  showMenu() {
    this.menu = !this.menu;
  }
}
