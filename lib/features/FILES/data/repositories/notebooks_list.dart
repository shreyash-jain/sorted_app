import 'package:flutter/material.dart';
import 'package:sorted/features/FILES/data/models/notebook_model.dart';

class NotebookList {
  String color1 = new Color(0xff6963a9).toString();

  static List<NotebookModel> notebooks = [
    NotebookModel(
        id: 10,
        title: "Quick Notes",
        icon: "⚡",
        noteEmoji: "⚡",
        listCategory: 1,
        description:
            "The one where you record everyday thoughts, ideas and plannings",
        color: Color(0xff6963a9).toString(),
        assetPath: "assets/images/notebooks/quicknote.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fjoanna-kosinska-9sV1A_szES0-unsplash%20(1).jpg?alt=media&token=252163a2-d2e7-4fe0-bca2-8b86b3be74a1"),
    NotebookModel(
        id: 20,
        title: "Grocery List",
        icon: "🛒",
        noteEmoji: "🛒",
        listCategory: 1,
        description:
            "The one where you record everyday grocery items, to avoid buying items you don't really need",
        color: Color(0xff373644).toString(),
        assetPath: "assets/images/notebooks/groceryList.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fscott-warman-NpNvI4ilT4A-unsplash%20(1).jpg?alt=media&token=762cb9ff-3805-4916-b497-4d798ccbaa67"),
    NotebookModel(
        id: 30,
        title: "Task List",
        icon: "✔️",
        noteEmoji: "✔️",
        listCategory: 1,
        description:
            "The one where you plan everyday tasks, to be prepared for everything",
        color: Color(0xffb4b360).toString(),
        assetPath: "assets/images/notebooks/taskList.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fdaria-nepriakhina-zoCDWPuiRuA-unsplash.jpg?alt=media&token=e0a377ff-ca8d-475b-b763-1ccf125768ee"),
    NotebookModel(
        id: 40,
        title: "Passwords",
        icon: "🔑",
        noteEmoji: "🔑",
        listCategory: 1,
        description: "The one where you record your everyday passwords",
        color: Color(0xffce7c54).toString(),
        assetPath: "assets/images/notebooks/passCodes.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fyura-fresh-dk4en2rFOIE-unsplash.jpg?alt=media&token=090e87ba-da2e-4d4d-b9f0-9168ece8b069"),
    NotebookModel(
        id: 50,
        title: "Personal Docs",
        icon: "🗎",
        noteEmoji: "🗎",
        listCategory: 1,
        description: "The one where you record your everyday Ids and Documents",
        color: Color(0xff5579cd).toString(),
        assetPath: "assets/images/notebooks/docsId.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fcardmapr-LVA3S6isNYQ-unsplash.jpg?alt=media&token=05881639-bed7-4551-ac59-d83e8184a587"),
    NotebookModel(
        id: 60,
        title: "Ideas Diary",
        icon: "💡",
        noteEmoji: "💡",
        listCategory: 1,
        description: "The one where you record your everyday innovative ideas",
        color: Color(0xff7698a7).toString(),
        assetPath: "assets/images/notebooks/ideasDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fisaac-newton.jpg?alt=media&token=7bc24d7b-fc16-4062-913b-1dda5e598250"),
    NotebookModel(
        id: 70,
        title: "Class Notes",
        icon: "📜",
        noteEmoji: "📜",
        listCategory: 2,
        description:
            "The one where you record your class notes in an effective way",
        color: Color(0xffe4e3e8).toString(),
        assetPath: "assets/images/notebooks/classNotes.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fgreen-chameleon-s9CC2SKySJM-unsplash.jpg?alt=media&token=37526398-752f-48b3-bd42-7762b494bd7e"),
    NotebookModel(
        id: 80,
        title: "Reading List",
        icon: "👓",
        noteEmoji: "👓",
        listCategory: 2,
        description:
            "The one where you record your notes, summary and new learnt words of the book you are currently reading",
        color: Color(0xff99dad2).toString(),
        assetPath: "assets/images/notebooks/readingList.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Ftudor-baciu-zYXhII8xgy0-unsplash.jpg?alt=media&token=df91ca65-09f1-4152-96e0-126181a78311"),
    NotebookModel(
        id: 90,
        title: "Syllabus",
        icon: "⌛",
        noteEmoji: "⌛",
        listCategory: 2,
        description:
            "The one where you record your course syllabus and its completion deadlines",
        color: Color(0xffbd5353).toString(),
        assetPath: "assets/images/notebooks/syllabusPlan.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fyou-x-ventures-Oalh2MojUuk-unsplash.jpg?alt=media&token=d585cee8-a13f-4189-8c15-fd959a656d10"),
    NotebookModel(
        id: 100,
        title: "Improvement Diary",
        icon: "🌱",
        noteEmoji: "🌱",
        listCategory: 2,
        description:
            "The one where you record your growth in learings and skills",
        color: Color(0xffa5d86a).toString(),
        assetPath: "assets/images/notebooks/improvementDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fpedro-kummel-xU1mshiwvfY-unsplash.jpg?alt=media&token=06db1bd2-2e25-4003-bbb1-5bcef087bec2"),
    NotebookModel(
        id: 110,
        title: "Work diary",
        icon: "💼",
        noteEmoji: "💼",
        listCategory: 2,
        description: "The one where you record how your work day went",
        color: Color(0xffd5c2d9).toString(),
        assetPath: "assets/images/notebooks/workDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fmarvin-meyer-SYTO3xs06fU-unsplash.jpg?alt=media&token=7c900cfd-e03b-40af-8be0-f0af48fa11ff"),
    NotebookModel(
        id: 120,
        title: "Expenses",
        icon: "💸",
        noteEmoji: "💸",
        listCategory: 3,
        description: "The one where you record your everyday expenses",
        color: Color(0xff93e3ea).toString(),
        assetPath: "assets/images/notebooks/expensesList.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fclaudio-schwarz-purzlbaum-S777K6ZnppY-unsplash.jpg?alt=media&token=033229e9-0b22-4cfa-8091-8e7cc58dd988"),
    NotebookModel(
        id: 130,
        title: "Birthdays",
        icon: "🎂",
        noteEmoji: "🎂",
        listCategory: 4,
        description:
            "The one where you record your reminders for birthdays and anniversaries",
        color: Color(0xfff199c1).toString(),
        assetPath: "assets/images/notebooks/birthdayLists.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fadi-goldstein-Hli3R6LKibo-unsplash.jpg?alt=media&token=f3d18539-0746-449e-89cb-ef7421d70e74"),
    NotebookModel(
        id: 140,
        title: "Memories",
        icon: "💡",
        noteEmoji: "💡",
        listCategory: 4,
        description:
            "The one where you record your friends and family events to remember",
        color: Color(0xff775786).toString(),
        assetPath: "assets/images/notebooks/memories.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Flaura-fuhrman-73OJLcahQHg-unsplash.jpg?alt=media&token=8125affc-ff92-4dd1-b184-0661aaa9a045"),
    NotebookModel(
        id: 150,
        title: "Travel Bucket",
        icon: "✈️",
        noteEmoji: "✈️",
        listCategory: 5,
        description:
            "The one where you record your wishlist of your dream places to visit in lifetime",
        color: Color(0xff3bf5e7).toString(),
        assetPath: "assets/images/notebooks/travelBucket.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fdino-reichmuth-A5rCN8626Ck-unsplash.jpg?alt=media&token=98a82d95-1b9f-41f9-b0eb-7361c4de65f3"),
    NotebookModel(
        id: 160,
        title: "Tv-Seies and Movies Bucket",
        icon: "🎥",
        noteEmoji: "🎥",
        listCategory: 5,
        description:
            "The one where you record your wishlist of movies and shows you want to watch later",
        color: Color(0xff96ac6e).toString(),
        assetPath: "assets/images/notebooks/moviesBucket.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fjeshoots-com-PpYOQgsZDM4-unsplash.jpg?alt=media&token=e36f8795-5cc9-4335-bd54-22fafd9dbcad"),
    NotebookModel(
        id: 170,
        title: "Shopping Bucket",
        icon: "🛍️",
        noteEmoji: "🛍️",
        listCategory: 5,
        description:
            "The one where you record your shopping items to buy later",
        color: Color(0xff328a71).toString(),
        assetPath: "assets/images/notebooks/shopList.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Ferik-mclean-nfoRa6NHTbU-unsplash.jpg?alt=media&token=9f522b1b-526a-45c8-9693-75045a1fcd74"),
    NotebookModel(
        id: 180,
        title: "Skin Diary",
        icon: "💆🏼",
        noteEmoji: "💆🏼",
        listCategory: 5,
        description: "The one where you record your face and skin improvement",
        color: Color(0xfff85f61).toString(),
        assetPath: "assets/images/notebooks/skinDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fjamie-street-aMuq-Xz7R_M-unsplash.jpg?alt=media&token=e68d9daa-2ad5-42e8-8200-9e5f38d9202a"),
    NotebookModel(
        id: 190,
        title: "Stress Diary",
        icon: "😇",
        noteEmoji: "😇",
        listCategory: 5,
        description: "The one where you record your anxieties and emotions",
        color: Color(0xff6499a9).toString(),
        assetPath: "assets/images/notebooks/stressDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Ftengyart-_VkwiVNCNfo-unsplash.jpg?alt=media&token=218f8476-7717-4af3-96fd-b439707615bd"),
    NotebookModel(
        id: 200,
        title: "Mood Diary",
        icon: "😊",
        noteEmoji: "😊",
        listCategory: 5,
        description:
            "The one where you record your mood and its causes and consequences",
        color: Color(0xff8b994a).toString(),
        assetPath: "assets/images/notebooks/moodDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fvictor-garcia-o-zkqbOeZQI-unsplash.jpg?alt=media&token=33b701ab-118a-4dd1-be0d-a594a12b408b"),
    NotebookModel(
        id: 210,
        title: "Food Diary",
        icon: "🍏",
        noteEmoji: "🍏",
        listCategory: 5,
        description: "The one where you record your food and its calories",
        color: Color(0xff30777b).toString(),
        assetPath: "assets/images/notebooks/foodDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fanna-pelzer-IGfIGP5ONV0-unsplash.jpg?alt=media&token=95e8cc91-db23-4e8a-ab17-1393f339024c"),
    NotebookModel(
        id: 220,
        title: "Gratitude Diary",
        icon: "🙏",
        noteEmoji: "🙏",
        listCategory: 5,
        description: "The one where you record your food and its calories",
        color: Color(0xfffad05a).toString(),
        assetPath: "assets/images/notebooks/gratitudeDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fgabrielle-henderson-Y3OrAn230bs-unsplash.jpg?alt=media&token=0a73c03b-c102-4935-89ed-a569d806776b"),
    NotebookModel(
        id: 230,
        title: "Travel Blog",
        icon: "🚗",
        noteEmoji: "🚗",
        listCategory: 6,
        description: "The one where you record your travel experiences",
        color: Color(0xff007169).toString(),
        assetPath: "assets/images/notebooks/travelBlog.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fjakob-owens-x56tnqZL9gA-unsplash.jpg?alt=media&token=c5293a11-de8d-4701-9f29-356ca7999b2e"),
    NotebookModel(
        id: 240,
        title: "Exercise Blogs",
        icon: "🏋️",
        noteEmoji: "🏋️",
        listCategory: 6,
        description: "The one where you record your Gym and Yoga experiences",
        color: Color(0xfffd783f).toString(),
        assetPath: "assets/images/notebooks/exerciseBlog.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fvictor-freitas-WvDYdXDzkhs-unsplash.jpg?alt=media&token=37da7317-0492-4a2e-a0c8-2891c98e8951"),
    NotebookModel(
        id: 250,
        title: "Relationship Blogs",
        icon: "💖",
        noteEmoji: "💖",
        listCategory: 6,
        description:
            "The one where you record your relationship moments and events",
        color: Color(0xfffe4040).toString(),
        assetPath: "assets/images/notebooks/loveBlogs.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Feverton-vila-AsahNlC0VhQ-unsplash.jpg?alt=media&token=5352ec42-ecb5-4280-aa71-f2c0ea9a31f9"),
    NotebookModel(
        id: 260,
        title: "Medicine Records",
        icon: "💊",
        noteEmoji: "💊",
        listCategory: 7,
        description:
            "The one where you record your medicine intake and its timings",
        color: Color(0xffb1ddea).toString(),
        assetPath: "assets/images/notebooks/medicineRecords.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fthought-catalog-LOTgbsD1_Y8-unsplash.jpg?alt=media&token=136c5041-c657-49a4-850f-53f01f67209e"),
    NotebookModel(
        id: 270,
        title: "Checkup Records",
        icon: "👨‍⚕️",
        noteEmoji: "👨‍⚕️",
        listCategory: 7,
        description: "The one where you record your medical checkups",
        color: Color(0xff938860).toString(),
        assetPath: "assets/images/notebooks/checkup.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fhush-naidoo-yo01Z-9HQAw-unsplash.jpg?alt=media&token=bdbd2bee-151b-4cee-8f85-1bf51d424ebd"),
    NotebookModel(
        id: 280,
        title: "Self Check-in",
        icon: "🖋️",
        noteEmoji: "🖋️",
        listCategory: 7,
        description: "The one where you record your health status",
        color: Color(0xff7b4c7a).toString(),
        assetPath: "assets/images/notebooks/selfCheck.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fmika-baumeister-xWtloyvoK0E-unsplash.jpg?alt=media&token=c3dbfe8b-c06f-442c-9a7b-2fc11a51e63f"),
    NotebookModel(
        id: 290,
        title: "Sleep Diary",
        icon: "💤",
        noteEmoji: "💤",
        listCategory: 5,
        description: "The one where you record your sleep pattern",
        color: Color(0xff2a2e2f).toString(),
        assetPath: "assets/images/notebooks/sleepDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fvladislav-muslakov-CwIU33KGToc-unsplash.jpg?alt=media&token=f057b540-2db9-4021-a602-0173de344e19"),
    NotebookModel(
        id: 300,
        title: "Diabetes Diary",
        icon: "🍏",
        noteEmoji: "🍏",
        listCategory: 7,
        description:
            "The one where you record your sugar and keep track of diabetes symptomns",
        color: Color(0xff6f6a80).toString(),
        assetPath: "assets/images/notebooks/diabetesDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fkate-GBVRyE4PRLk-unsplash.jpg?alt=media&token=1a0e0a3d-9037-4633-812a-85ce65a7201a"),
    NotebookModel(
        id: 310,
        title: "Blood Pressure Diary",
        icon: "🩸",
        noteEmoji: "🩸",
        listCategory: 7,
        description: "The one where you record your bp",
        color: Color(0xff404e40).toString(),
        assetPath: "assets/images/notebooks/bpDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fanna-pelzer-IGfIGP5ONV0-unsplash.jpg?alt=media&token=95e8cc91-db23-4e8a-ab17-1393f339024c"),
    NotebookModel(
        id: 320,
        title: "Menstrual Diary",
        icon: "👧🏻",
        noteEmoji: "👧🏻",
        listCategory: 7,
        description:
            "The one where you record your menstrual changes and behaviour",
        color: Color(0xffe47ca8).toString(),
        assetPath: "assets/images/notebooks/menstrualDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fgabrielle-rocha-rios-phGZuTjjZFE-unsplash.jpg?alt=media&token=a5caf61f-3317-4d12-99bd-cf7e3e4ab4d1"),
    NotebookModel(
        id: 330,
        title: "Asthma Diary",
        icon: "🌬️",
        noteEmoji: "🌬️",
        listCategory: 7,
        description: "The one where you record your food and its calories",
        color: Color(0xff77dbfc).toString(),
        assetPath: "assets/images/notebooks/asthmaDiary.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fvictor-garcia-BiGS_w9t7FU-unsplash.jpg?alt=media&token=99574652-d12e-4fc2-a987-ece37d27ed6d"),
    NotebookModel(
        id: 340,
        title: "Bills Receipts",
        icon: "💵",
        noteEmoji: "💵",
        listCategory: 3,
        description: "The one where you record your shopping receipts",
        color: Color(0xffb899bb).toString(),
        assetPath: "assets/images/notebooks/billReceipts.jpg",
        canDelete: 0,
        cover:
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fcarli-jeen-UWRqlJcDCXA-unsplash.jpg?alt=media&token=cc8f5cd5-2e5d-4b2a-9a40-bedda9d95d45"),
  ];
}
