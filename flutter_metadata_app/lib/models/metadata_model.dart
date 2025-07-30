class MetadataModel {
  String title;
  String subject;
  String tags;
  String comments;
  String authors;
  String copyright;

  MetadataModel({
    this.title = '',
    this.subject = '',
    this.tags = '',
    this.comments = '',
    this.authors = '',
    this.copyright = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Subject': subject,
      'Tags': tags,
      'Comments': comments,
      'Authors': authors,
      'Copyright': copyright,
    };
  }

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
      title: json['Title'] ?? '',
      subject: json['Subject'] ?? '',
      tags: json['Tags'] ?? '',
      comments: json['Comments'] ?? '',
      authors: json['Authors'] ?? '',
      copyright: json['Copyright'] ?? '',
    );
  }

  MetadataModel copyWith({
    String? title,
    String? subject,
    String? tags,
    String? comments,
    String? authors,
    String? copyright,
  }) {
    return MetadataModel(
      title: title ?? this.title,
      subject: subject ?? this.subject,
      tags: tags ?? this.tags,
      comments: comments ?? this.comments,
      authors: authors ?? this.authors,
      copyright: copyright ?? this.copyright,
    );
  }

  void clear() {
    title = '';
    subject = '';
    tags = '';
    comments = '';
    authors = '';
    copyright = '';
  }

  bool get isEmpty {
    return title.isEmpty &&
        subject.isEmpty &&
        tags.isEmpty &&
        comments.isEmpty &&
        authors.isEmpty &&
        copyright.isEmpty;
  }

  @override
  String toString() {
    return 'MetadataModel(title: $title, subject: $subject, tags: $tags, comments: $comments, authors: $authors, copyright: $copyright)';
  }
} 