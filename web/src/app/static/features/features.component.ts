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
        icon: 'assets/images/icon/4.png',
        subtitle: 'Fitness community that you need',
        subText:
          'Connect with the people who too are health conscious just like you, post the daily fitness challenge in 15 sec short video and see how others are getting shredded  and building muscles',
      },
      {
        icon: 'assets/images/icon/1.png',
        subtitle: 'Fitness Tracking',
        subText:
          'The best in class tracking and analysis of more that 100 tracks (Yes you heard it right) in Fitness, Nutrition and Mindfulness, from Food to Workout we cover all of them',
      },
      {
        icon: 'assets/images/icon/4.png',
        subtitle: 'Experts in a click',
        subText:
          'Always been too worked up or confused to record the day to day expenses and transactions?<br>Not anymore, we have the most simplified solution for you. Here, you may easily keep an account of all your expenses along with setting up a budget check which makes it all the more user friendly.',
      },
      {
        icon: 'assets/images/icon/2.png',
        subtitle: 'Meal and Workout Plans',
        subText:
          'Let’s take a step further to plan and strategize your goals by adding some fun tasks to your profile. As you clear each milestone you’ll get a reward. You can constantly track and analyze your progress with our daily planners.',
      },
      {
        icon: 'assets/images/icon/3.png',
        subtitle: 'Health Records',
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
