import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FeaturesComponent } from './static/features/features.component';
import { FeaturesExpertsComponent } from './static/features_experts/features_experts.component';
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
import { ContactUsService } from './contact-us.service';

@NgModule({
  declarations: [
    AppComponent,
    FeaturesComponent,
    FeaturesExpertsComponent,
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
    HttpClientModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    NgbModule,
    CarouselModule,
    ReactiveFormsModule
  ],
  providers: [ContactUsService],
  bootstrap: [AppComponent]
})
export class AppModule { }
