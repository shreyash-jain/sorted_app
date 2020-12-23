import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FeaturesComponent } from './static/features/features.component';
import { HeaderComponent } from './static/header/header.component';
import { HomeComponent } from './static/home/home.component';
import { IntroComponent } from './static/intro/intro.component';
import { AboutComponent } from './static/about/about.component';
import { ScreenshotComponent } from './static/screenshot/screenshot.component';
import { TeamComponent } from './static/team/team.component';
import { BlogComponent } from './static/blog/blog.component';
import { PriceComponent } from './static/price/price.component';
import { ContactUsComponent } from './static/contact-us/contact-us.component';
import { NewsletterComponent } from './static/newsletter/newsletter.component';
import { FooterComponent } from './static/footer/footer.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { CarouselModule } from 'ngx-owl-carousel-o';
import { TestimonialComponent } from './static/testimonial/testimonial.component';
import { ReactiveFormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    AppComponent,
    FeaturesComponent,
    HeaderComponent,
    HomeComponent,
    IntroComponent,
    AboutComponent,
    ScreenshotComponent,
    TeamComponent,
    BlogComponent,
    PriceComponent,
    ContactUsComponent,
    NewsletterComponent,
    FooterComponent,
    TestimonialComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    NgbModule,
    CarouselModule,
    ReactiveFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }