import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-features',
  templateUrl: './features.component.html',
  styleUrls: ['./features.component.scss'],
})
export class FeaturesComponent implements OnInit {
  featuresData = [
    [
      {
        icon: 'assets/images/icon/1.png',
        subtitle: 'Introspect',
        subText:
          'Let’s track your activities and get an insight into your world to make it all the more amazing.',
      },
      {
        icon: 'assets/images/icon/3.png',
        subtitle: 'Record',
        subText:
          'We have a creative tool to simplify your work. We have a pool of customizable templates to record each and every aspect of your life as in bucket lists, memoirs, blogs, appointments and what not along with an option to create self designed templates.',
      },
      // {
      //   icon: 'assets/images/icon/5.png',
      //   subtitle: 'Unlimited Features',
      //   subText:
      //     'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      // },
    ],
    [
      {
        icon: 'assets/images/icon/2.png',
        subtitle: 'Plan',
        subText:
          'Let’s take a step further to plan and strategize your goals by adding some fun tasks to your profile. As you clear each milestone you’ll get a reward. You can constantly track and analyze your progress with our daily planners.',
      },
      {
        icon: 'assets/images/icon/4.png',
        subtitle: 'Money',
        subText:
          'Always been too worked up or confused to record the day to day expenses and transactions?<br>Not anymore, we have the most simplified solution for you. Here, you may easily keep an account of all your expenses along with setting up a budget check which makes it all the more user friendly.',
      },
      // {
      //   icon: 'assets/images/icon/6.png',
      //   subtitle: '24 x 7 Support',
      //   subText:
      //     'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      // },
    ],
  ];

  constructor() {}

  ngOnInit(): void {}
}
