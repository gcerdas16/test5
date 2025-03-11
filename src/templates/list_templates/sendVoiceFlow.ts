import { addKeyword } from "@builderbot/bot";

const sendVoiceFlow = addKeyword("GS0310973").addAnswer("Te adjunto un PDF", {
  media: 'https://asset.cloudinary.com/dj0i57kxn/6dd6074b26cf5dd3937481d19885ccb4',
});

export { sendVoiceFlow };
