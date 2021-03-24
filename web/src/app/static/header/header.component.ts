import { Component, HostListener, OnInit } from '@angular/core';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
})
export class HeaderComponent implements OnInit {
  public isScrolled: boolean = false;
  public LogoOpacity: number = 0;
  @HostListener('window:scroll', ['$event']) onScrollEvent($event) {
    let logoElement = document.getElementById('AppName');
    this.LogoOpacity = $event.target['scrollingElement'].scrollTop/logoElement.offsetTop;
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
      name: 'Register',
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
